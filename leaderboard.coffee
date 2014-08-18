exports = this
exports.PlayersList = new Meteor.Collection('players')

if Meteor.isClient
  # Template function for players
  Template.leaderboard.player = ->
    PlayersList.find()

  # Event function to add clicked player's id to the session
  Template.leaderboard.events {
    'click li.player': ->
      Session.set('selectedPlayer', this._id)
      selectedPlayer = Session.get('selectedPlayer')
      console.log(selectedPlayer)
  }

  # Helper function to add 'selected' class to li element
  Template.leaderboard.selectedClass = ->
    selectedPlayer = Session.get('selectedPlayer')
    if selectedPlayer is this._id
      'selected'

    
if Meteor.isServer
  # execute server-side code      
  null
