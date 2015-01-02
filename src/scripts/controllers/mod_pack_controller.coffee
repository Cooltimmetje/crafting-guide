###
# Crafting Guide - mod_pack_controller.coffee
#
# Copyright (c) 2014 by Redwood Labs
# All rights reserved.
###

BaseController       = require './base_controller'
{DefaultBookUrls}    = require '../constants'
ModVersionController = require './mod_version_controller'

########################################################################################################################

module.exports = class ModPackController extends BaseController

    constructor: (options={})->
        if not options.model? then throw new Error "options.model is required"
        @_bookControllers = []

        options.templateName = 'mod_pack'
        super options

    # BaseController Overrides #####################################################################

    onWillRender: ->
        if @model.books.length is 0
            @model.loadAllBooks DefaultBookUrls

    onDidRender: ->
        @$table = @$('table')
        super

    refresh: ->
        @$('table tr:not(:last-child)').remove()
        return unless @model?

        @_bookControllers = []
        for i in [@model.books.length-1..0] by -1
            book = @model.books[i]
            controller = new ModVersionController model:book
            controller.render()
            @_bookControllers.push controller
            @$table.prepend controller.$el

        super