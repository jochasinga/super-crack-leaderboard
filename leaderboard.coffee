exports = this
exports.PlayersList = new Meteor.Collection('players')

if Meteor.isClient
	
  Meteor.subscribe('thePlayers')
	
  # Template function for players
  Template.leaderboard.player = ->
    currentUserId = Meteor.userId()
    PlayersList.find(
      {createdBy: currentUserId}
      {sort: {score: -1, name: 1}}
    )

  # Event function to add clicked player's id to the session
  Template.leaderboard.events({
    'click li.player': ->
      Session.set('selectedPlayer', this._id)
      selectedPlayer = Session.get('selectedPlayer')
      console.log(selectedPlayer)
		
    'click #increment': ->
      selectedPlayer = Session.get('selectedPlayer')
      Meteor.call('updatePlayerScore', selectedPlayer, direction=5)

    'click #decrement': ->
      selectedPlayer = Session.get('selectedPlayer')
      Meteor.call('updatePlayerScore', selectedPlayer, direction=-5)
		
    'click #remove': ->
      selectedPlayer = Session.get('selectedPlayer')
      Meteor.call('removePlayer', selectedPlayer)
  })

  Template.addPlayerForm.events({
    'submit form': (theEvent, theTemplate) ->
      theEvent.preventDefault()
      playerName = theTemplate.find('#playerName').value
      Meteor.call('insertPlayerData', playerName)
  })

  # Helper function to add 'selected' class to li element
  Template.leaderboard.selectedClass = ->
    selectedPlayer = Session.get('selectedPlayer')
    if selectedPlayer is this._id
      'selected'

  Template.leaderboard.showSelectedPlayer = ->
    selectedPlayer = Session.get('selectedPlayer')
    PlayersList.findOne(selectedPlayer)
    
if Meteor.isServer
  # execute server-side code
  Meteor.publish('thePlayers', ->
    currentUserId = this.userId
    PlayersList.find({createdBy: currentUserId}) if currentUserId
  )

  Meteor.methods({
    'insertPlayerData': (playerName) ->
      currentUserId = Meteor.userId()
      PlayersList.insert({
        name: playerName
        score: 0
        createdBy: currentUserId
      })

    'removePlayer': (selectedPlayer) ->
      PlayersList.remove(selectedPlayer)

    'updatePlayerScore': (selectedPlayer, direction) ->
      PlayersList.update(
        {_id: selectedPlayer},
        {$inc: {score: direction}}
      )
  })

