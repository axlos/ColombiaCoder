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
$("#slider_range").slider({
      range: true,
      min: 1000000,
      max: 10000000,
      step: 500000,
      values: [$("#job_salary_range_ini").val(), $("#job_salary_range_fin").val()],
      slide: (event, ui ) ->
        # Visualizar los rangos salariales en los label
        if ui.values[0] <= (1000000)
          $("#range_ini").text('Menos $1,000,000')
        else
          $("#range_ini").text(ui.values[0]).formatCurrency({roundToDecimalPlace: 0})
        if ui.values[1] >= (10000000)
          $("#range_fin").text('Mas $10,000,000')
        else
          $("#range_fin").text(ui.values[1]).formatCurrency({roundToDecimalPlace: 0})
        
        $("#job_salary_range_ini").val(ui.values[0])
        $("#job_salary_range_fin").val(ui.values[1])
});

# Formato de moneda para el slider
$("#range_ini").text($("#slider_range").slider("values", 0)).formatCurrency({roundToDecimalPlace: 0}) if $("#range_ini").length isnt 0
$("#range_fin").text($("#slider_range").slider("values", 1)).formatCurrency({roundToDecimalPlace: 0}) if $("#range_fin").length isnt 0

# funtion para habilitar o deshabilitar slider
Salary_negotiable_slider = (checked) ->
  if checked is "false"
    $('#slider_range').slider("enable")
    $("#range_ini").attr('class', "");
    $("#range_fin").attr('class', "");
  else
    $('#slider_range').slider("disable")
    $("#range_ini").attr('class', "muted");
    $("#range_fin").attr('class', "muted");

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

# Depende del valor que seleccione del checkbox cambia el hidden para ser guardado
$("#no_experience_required").bind 'click', (event) =>
  $("#job_no_experience_required").val($("#no_experience_required").is(':checked'))


# autocomplete de tecnologias, ver: http://www.linkedin.com/ta/skill
skillCmp = $('#job_technology_ids')

skillCmp.ajaxChosen({
  url: 'http://www.linkedin.com/ta/skill',
  dataType: 'jsonp',
  jsonTermKey: 'query',
  minTermLength: 1
},(data) ->
  terms = {};
  $.each(data.resultList, (i, val) ->
    terms[val.displayName] = val.displayName;
  );
  return terms;
{allow_single_deselect: true })