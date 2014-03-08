# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Habilitar wysihtml5 sobre el componente de perfil
$('#profile_summary').wysihtml5({
  "font-styles": false, #Font styling, e.g. h1, h2, etc. Default true
  "emphasis": true, #Italics, bold, etc. Default true
  "lists": true, #(Un)ordered lists, e.g. Bullets, Numbers. Default true
  "html": false, #Button which allows you to edit the generated HTML. Default false
  "link": false, #Button to insert a link. Default true
  "image": false #Button to insert an image. Default true
})

# autocomplete de tecnologias, ver: http://www.linkedin.com/ta/skill
skillCmp = $('#profile_technology_ids')

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