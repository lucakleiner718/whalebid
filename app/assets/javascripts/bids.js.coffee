# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on 'ready page:load', ->
  	$("input[name='bid[wager_level]']").each ->
    	if $(this).is(":checked")
    		console.log($(this).data("player-category"))
    		$("#bid_player_category").val( $(this).data("player-category") )
    		$("#bid_bid_fee").val( $(this).data("bid-fee") )
    	return
  	return