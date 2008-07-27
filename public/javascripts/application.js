// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


function createPlayer(id, url)  {
  alert(id);
  
}

function startSlider(slider, sound) {
  sound.getPosition();
}


function startPlay(id, soundObject) {
  if(soundObject) {
    soundObject.loadSound('#{track.public_filename}', true);this.hide();$('player_object_stop_#{track.id}').show();
  }
}

function createSlider(id) {
 var player_handler_id = 'player_handler_' + id
 var player_slider_id = 'player_slider_' + id
  
 var slider = new Control.Slider(player_handler_id,player_slider_id,{
   sliderValue:0, onSlide:function(v){$('debug1').innerHTML='slide: '+v},
   onChange:function(v){$('debug1').innerHTML='changed! '+v}});
 };

 return slider;
}