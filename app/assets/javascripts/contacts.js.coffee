# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
# autocomplete de ciudades, ver: http://www.geonames.org/
$('#contact_geoname').autocomplete({
  source: (request, response) ->
        $.ajax({
          url: "http://ws.geonames.org/searchJSON",
          dataType: "jsonp",
          data: {
            country: "CO",
            featureClass: "P",
            maxRows: 5,
            name_startsWith: request.term,
            lang: "es",
            type: "json"
          },
          success: (data) ->
            response ($.map(data.geonames, (item) ->
              return {
                label: item.name + (if item.adminName1 then ", " + item.adminName1 else "") + ", " + item.countryName, 
                value: item.name + (if item.adminName1 then ", " + item.adminName1 else "") + ", " + item.countryName,
                id: item.geonameId
              }
            ))
        })
  ,minLength: 2
  ,max: 2
  ,select: (event, ui) ->
    # Set el geonameId data json a el hidden que guardara el valor
    $("#contact_geoname_id").val(ui.item.id)
})
