var currentlyPlaying = null;
var sounds = new Array();

function startSlider(soundObject) {
  slider = soundObject.slider;
  var durationObserver = null;

  if(slider) {  
    slider.range = $R(0,100);
    soundObject.slider.setValue(0,0);

    durationObserver = new PeriodicalExecuter(function() {
      // $('debug1').innerHTML = "Duration: " + soundObject.getDuration() + " / Position : " + soundObject.getPosition() + " / Value : " + slider.value;
      // slider.setValue(soundObject.getPosition(), 0);
      var newvalue = (soundObject.getPosition() / soundObject.getDuration()) * 100;
      slider.setValue(newvalue, 0);
      
    },.50);

    slider.trackObserver = durationObserver;  
    durationObserver.execute();
  }
    
  return durationObserver;
}

function stopPlay() {

  if(currentlyPlaying) {
    currentlyPlaying.stop();
    eval("$('player_object_" + currentlyPlaying.sound_id + "').show();");
    eval("$('player_object_stop_" + currentlyPlaying.sound_id + "').hide();");
    
    if(currentlyPlaying.slider && currentlyPlaying.slider.trackObserver) {
      currentlyPlaying.slider.setValue(0,0);
      currentlyPlaying.slider.trackObserver.stop();
    }
  }

  // soundObject = null;
  currentlyPlaying = null;
}

function createPlayer(id, filename) {
  var soundObject = new Sound();
  soundObject.sound_id = id;
  soundObject.filename = filename;
  sounds[sounds.length] = soundObject;
  return soundObject;
}

function startPlay(id) {

  for(i = 0; i <= sounds.length - 1; i++) {
    if(sounds[i].sound_id == id) {
      soundObject = sounds[i];
      // soundObject = createPlayer(sounds[i].sound_id, sounds[i].filename);
      // sounds[i] = soundObject;
    }
  }

  if(soundObject) {

    if(currentlyPlaying) {
      currentlyPlaying.stop();
      stopPlay(currentlyPlaying);
      currentlyPlaying = null;
    }
    
    currentlyPlaying = soundObject;
    
    soundObject.loadSound(soundObject.filename, true);
    // soundObject.start(0, 1);
  
    if(!soundObject.slider) {
      soundObject.slider = createSlider(soundObject.sound_id);
      soundObject.slider.soundObject = soundObject;
    }
    
    soundObject.setPosition("0");
    soundObject.slider.setValue(0,0);
    startSlider(soundObject);
    
    eval("$('player_object_" + soundObject.sound_id + "').hide();");
    eval("$('player_object_stop_" + soundObject.sound_id + "').show();");
  }
  
}

function createSlider(id) {
 var player_handler_id = 'player_handler_' + id;
 var player_slider_id = 'player_slider_' + id;
  
 var slider = new Control.Slider(player_handler_id, player_slider_id, { sliderValue:0, onSlide:function(v){
   // currentlyPlaying.setPosition(v);
   $('debug1').innerHTML='slide: '+ v;
   }, 
 onChange:function(v){
    // currentlyPlaying.setPosition(v);
 }
 });

 return slider;
}
