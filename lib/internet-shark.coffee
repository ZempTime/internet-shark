InternetSharkView = require './internet-shark-view'
{CompositeDisposable} = require 'atom'

module.exports = InternetShark =
  internetSharkView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @internetSharkView = new InternetSharkView(state.internetSharkViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @internetSharkView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'internet-shark:toggle': => @toggle()
    @sound = new Audio('atom://internet-shark/sounds/omnom.mp3')

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @internetSharkView.destroy()

  serialize: ->
    internetSharkViewState: @internetSharkView.serialize()

  toggle: ->
    console.log 'InternetShark was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
      editor = atom.workspace.getActiveTextEditor()
      editor.delete(editor.selectAll())
      @sound.play()
