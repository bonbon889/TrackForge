// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var currentlyPlaying = null;

function createPlayer(id, url)  {
  alert(id); 
}


function getSoundObject(id) {
  eval("var soundObject = sound_" + id); // create object
  if(soundObject) {
    return soundObject;
  } else {
    return false;
  }
}

function getSlider(id) {
  eval("var slider = slider_" + id);
  return slider;
}

function startSlider(id) {
  soundObject = getSoundObject(id);
  slider = getSlider(id);
  
  if(slider) {  
    slider.range = $R(0,100);
    durationObserver = new PeriodicalExecuter(function() {
      $('debug1').innerHTML = "Duration: " + soundObject.getDuration() + " / Position : " + soundObject.getPosition() + " / Value : " + slider.value;
      // slider.setValue(soundObject.getPosition(), 0);
      var newvalue = (soundObject.getPosition() / soundObject.getDuration()) * 100;
      
      slider.setValue(newvalue, 0);
    },1);
  
  }
  
  durationObserver.execute();
  
  return durationObserver;
}

function stopPlay(id) {
  
  soundObject = getSoundObject(id);
  if(soundObject) {
    soundObject.stop();
    eval("$('player_object_" + id + "').show();");
    eval("$('player_object_stop_" + id + "').hide();");
  }

  slider = getSlider(id);
  slider.value = 0;

  
  currentlyPlaying = soundObject;
}

function startPlay(id) {
  soundObject = getSoundObject(id);
  if(soundObject) {
    startSlider(id);
    soundObject.loadSound(soundObject.filename, true);
    eval("$('player_object_" + id + "').hide();");
    eval("$('player_object_stop_" + id + "').show();");
  }
}

function createSlider(id) {
 var player_handler_id = 'player_handler_' + id;
 var player_slider_id = 'player_slider_' + id;
  
 var slider = new Control.Slider(player_handler_id, player_slider_id, { sliderValue:0, onSlide:function(v){$('debug1').innerHTML='slide: '+ v }, 
 onChange:function(v){
   

 }
 });

 return slider;
}
