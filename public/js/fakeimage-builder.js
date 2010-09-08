$(function(){

  $('form input')
    .bind('ready change keyup', function(e){
      var
	$this = $(this),
	$preview = $('#preview img'),
	$code = $('#code code'),
	width = $('#width').val(),
	height = $('#height').val(),
	format = 'png', //$('#format').val(),
	background_colour = $('#background-colour').val().replace('#', '!'),
	foreground_colour = $('#foreground-colour').val().replace('#', '!'),

	fakeimage_src = fakeimage_src_template
	  .replace(/{width}/gi, width)
	  .replace(/{height}/gi, height)
	  .replace(/{format}/gi, format)
	  .replace(/{background-colour}/gi, background_colour)
	  .replace(/{foreground-colour}/gi, foreground_colour)
	;

      $preview.attr('src', fakeimage_src);
      $code.text('<img src="http://'+host+fakeimage_src+' width="'+width+'" height="'+height+'" alt="">');
    })
    .trigger('ready')
  ;

  // Can't seem to access the input element from inside onChange, so shit is getting duplicated for now
  $('form input#background-colour').ColorPicker({livePreview: true, 
      onSubmit: function(hsb, hex, rgb, el) {
	$(el).val('#' + hex);
	$(el).ColorPickerHide();
      },
      onChange: function(hsb, hex, rgb) {
	//$('#background-colour').val('#' + hex).trigger('change');
      },
      onBeforeShow: function () {
	$(this).ColorPickerSetColor(this.value);
      }
  });

  $('form input#foreground-colour').ColorPicker({livePreview: true, 
      onSubmit: function(hsb, hex, rgb, el) {
	$(el).val('#' + hex);
	$(el).ColorPickerHide();
      },
      onChange: function(hsb, hex, rgb) {
	//$('#foreground-colour').val('#' + hex).trigger('change');
      },
      onBeforeShow: function () {
	$(this).ColorPickerSetColor(this.value);
      }
  });


});

