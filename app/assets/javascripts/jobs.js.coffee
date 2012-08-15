# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Evento para habilitar y deshabilitar aplicar la oferta
$("[name='job[resume_directly]']").bind 'click', (event) =>
    if $("input[name='job[resume_directly]']:checked").val() is "true"
       $('#job_email_address').prop('disabled', false)
       $('#job_application_details').prop('disabled', true)
       $('#job_email_address').focus()
    else
      $('#job_email_address').prop('disabled', true)
      $('#job_application_details').prop('disabled', false)
      $('#job_application_details').focus()
    true

# Aplicar JQuery-UI lider
$("#slider-range").slider({
      range: true,
      min: 1000000,
      max: 15000000,
      step: 500000,
      values: [$("#job_salary_range_ini").val(), $("#job_salary_range_fin").val()],
      slide: (event, ui ) ->
        $("#range-ini").text(ui.values[0]).formatCurrency()
        $("#range-fin").text(ui.values[1]).formatCurrency()
        $("#job_salary_range_ini").val(ui.values[0])
        $("#job_salary_range_fin").val(ui.values[1])
});

# Formato de moneda para el slider      
$("#range-ini").text($("#slider-range").slider("values", 0)).formatCurrency()
$("#range-fin").text($("#slider-range").slider("values", 1)).formatCurrency()

# funtion para habilitar o deshabilitar slider
Salary_negotiable_slider = (checked) ->
  if checked is "false"
    $('#slider-range').slider("enable")
    $("#range-ini").attr('class', "");
    $("#range-fin").attr('class', "");
  else
    $('#slider-range').slider("disable")
    $("#range-ini").attr('class', "muted");
    $("#range-fin").attr('class', "muted");

# Evento para habilitar y deshabilitar salario negociable
$("[name='job[salary_negotiable]']").bind 'click', (event) =>
    Salary_negotiable_slider $("input[name='job[salary_negotiable]']:checked").val()
    true
    
# Habilitar y deshabilitar salario negociable
Salary_negotiable_slider $("input[name='job[salary_negotiable]']:checked").val()

# Aplicar wysihtml5 a los controles
$('#job_company_description, #job_job_description').wysihtml5({
  "font-styles": false, #Font styling, e.g. h1, h2, etc. Default true
  "emphasis": true, #Italics, bold, etc. Default true
  "lists": true, #(Un)ordered lists, e.g. Bullets, Numbers. Default true
  "html": false, #Button which allows you to edit the generated HTML. Default false
  "link": false, #Button to insert a link. Default true
  "image": false #Button to insert an image. Default true
})

# autocomplete de ciudades, ver: http://www.geonames.org/
$('#job_geoname').autocomplete({
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
    $("#job_geoname_id").val(ui.item.id)
})

# Depende del valor que seleccione del checkbox cambia el hidden para ser guardado
$("#no_experience_required").bind 'click', (event) =>
  $("#job_no_experience_required").val($("#no_experience_required").is(':checked'))


# autocomplete de tecnologias, ver: http://www.linkedin.com/ta/skill
$("#mytags").tagit();