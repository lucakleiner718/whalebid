# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
	$("input").keypress ->
	  	if $(this).hasClass('number') and window.event and window.event.keyCode is 13
	  		newValue = new Intl.NumberFormat().format($(this).val().replace(",", ""));
	  		if not isNaN($(this).val().replace(",", ""))
	  			$(this).val( newValue );
	  		else
	  			$(this).val("0")


	  	return not (window.event and window.event.keyCode is 13)


	$("form").on "submit", (e) ->
    	$("input.number").each -> 
	    	$(this).val( $(this).val().replace(",", "") )
    	return true;

	$("input.number").each -> 
	    newValue = new Intl.NumberFormat().format($(this).val().replace(",", ""));
	    if not isNaN($(this).val().replace(",", ""))
	    	$(this).val( newValue );
	    else
	    	$(this).val("0")
	    return

	# subscription selection event
  	$(".subscription-select-btn").click (e) ->
    	e.preventDefault()
    	$("#user_casino_attributes_subscription").val $(this).data("value")
    	console.log $(this).data("value")
    	$(".subscription-select-btn").removeClass "btn-primary"
    	$(this).addClass "btn-primary"
    	$("#user_casino_attributes_subscription_preview").text("Subscription Plan ($" + new Intl.NumberFormat().format($(this).data("value")) + "/Mo)");
    	return

    # initializing the subscription
  	$(".subscription-select-btn").each ->
    	$(this).addClass "btn-primary"  if $(this).data("value") + "" is $("#user_casino_attributes_subscription").val() + ""
    	return

  	$(".subscription-select-btn.first").addClass "btn-primary"  if $("#user_casino_attributes_subscription").val() is ""

  	$("input[type='file']").on "change", (e) ->
	  	input = this
	  	console.log('file changed');
	  	if input.files and input.files[0]
	    	reader = new FileReader()
	    	reader.onload = (e) ->
	      		$("." + $(input).attr("id") + "_preview").attr "src", e.target.result
	      		console.log(e.target.result)
	      		return

	    	reader.readAsDataURL input.files[0]
	  	return

  	$(".number").on "change", (e) ->
  		console.log($(this).val());
  		newValue = new Intl.NumberFormat().format($(this).val().replace(",", ""));
  		if not isNaN($(this).val().replace(",", ""))
  			$(this).val( newValue );
  		else
  			$(this).val("0")

  	# shown event for the review tab on the casino
  	$("#casinoTab a").on "shown.bs.tab", (e) ->
  		console.log("last tab");
	  	# e.target // activated tab
	  	# e.relatedTarget // previous tab

	  	$("input, textarea").each ->
    		$("#" + $(this).attr("id") + "_preview").html $(this).val().replace(/\n/g, "<br />")  unless "user_casino_attributes_subscription" is $(this).attr("id")
	    	return

	    $("select").each ->
    		if $(this).attr("id") != undefined && $(this).attr("id").indexOf("_2i") != -1
    			$("#" + $(this).attr("id") + "_preview").html $(this).val() unless "user_casino_attributes_subscription" is $(this).attr("id")
    		else if $(this).val() != ""
    			$("#" + $(this).attr("id") + "_preview").html $("#" + $(this).attr("id") + " option:selected").text() unless "user_casino_attributes_subscription" is $(this).attr("id")
    			$("#" + $(this).attr("id") + "_count_preview").html $("#" + $(this).attr("id") + " option:selected").html().replace($("#" + $(this).attr("id") + " option:selected").val() + "(", "").replace(")", "") if "bid_market" is $(this).attr("id")
    			$("#" + $(this).attr("id") + "_preview").html $("#" + $(this).attr("id") + " option:selected").val() if "bid_market" is $(this).attr("id")
    		else
    			$("#" + $(this).attr("id") + "_preview").html "" unless "user_casino_attributes_subscription" is $(this).attr("id")

	    	return

	    if $("#bid_arrival_date") && $("#bid_arrival_date").val() != undefined
	    	bid_arrival_date = new Date($("#bid_arrival_date").val() + "T12:00:00");
	    	options = {
			    weekday: "long", year: "numeric", month: "long",
			    day: "numeric"
			};
	    	console.log($("#bid_arrival_date").val() + " 12:00:00 AM");
	    	$("#bid_arrival_date_preview").html(dateFormat(bid_arrival_date, "fullDate"));


	    if $("#bid_departure_date") && $("#bid_departure_date").val() != undefined
	    	bid_departure_date = new Date( $("#bid_departure_date").val() + "T12:00:00" );
	    	options = {
			    weekday: "long", year: "numeric", month: "long",
			    day: "numeric"
			};

	    	$("#bid_departure_date_preview").html(dateFormat(bid_departure_date, "fullDate"));

	    $("input[name='bid[wager_level]']").each ->
	    	if $(this).is(":checked")
	    		console.log($(this).data("bid-fee"))
	    		$("#bid_player_category").val( $(this).data("player-category") )
	    		$("#bid_bid_fee").val( $(this).data("bid-fee") )
	    		$(".bid_player_category_preview").html $(this).data("player-category")
	    		$(".bid_wager_level_preview").html $(this).val()
	    		$(".bid_bid_fee_preview").html new Intl.NumberFormat().format($(this).data("bid-fee"))
	    		$("#bid_player_category_preview").html $(this).data("player-category")
	    		$("#bid_wager_level_preview").html $(this).val()
	    		$("#bid_bid_fee_preview").html new Intl.NumberFormat().format($(this).data("bid-fee"))
	    	return


	    $("input[type='checkbox']").each ->
	    	if $(this).is(':checked')
	    		$("#" + $(this).attr("id") + "_preview").text "Yes"
	    	else
	    		$("#" + $(this).attr("id") + "_preview").text "No"
	  	
	  	if $("#bid_bid_fee_reimbursement").is(":checked")
	  		$("#bid_bid_fee_reimbursement_text_preview").show()
	  	else
	  		$("#bid_bid_fee_reimbursement_text_preview").hide()

	  	$("input[type='radio']").each ->
	    	if $(this).is(':checked') and $(this).attr("id") != undefined
	    		if $(this).val() == "true"
	    			$("#" + $(this).attr("id").replace("_true", "").replace("_false", "") + "_preview").text "Yes"
	    		else
	    			$("#" + $(this).attr("id").replace("_true", "").replace("_false", "") + "_preview").text "No"
	  	
	  	$("input[name='bid[by_market]']").each ->
	    	if $(this).is(':checked') and $(this).attr("id") != undefined
    			console.log($(this).attr("id"))
    			$("#" + $(this).attr("id") + "_preview").prop('checked', true);

	  	return
	
  	return


