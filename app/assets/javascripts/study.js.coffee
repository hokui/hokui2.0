# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).bind 'cbox_complete', (event) ->
    $('#colorbox img').css('display', 'none')
    $('#colorbox #Table3 tr:first').css('display', 'none')
