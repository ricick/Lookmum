
package com.lookmum.view 
{

	import com.lookmum.events.DragEvent;
	import com.lookmum.events.MediaPlayerEvent;
	import com.lookmum.util.IMediaPlayer;
	import com.lookmum.util.SoundManager;
	import com.lookmum.util.TimeCodeUtil;
	import com.lookmum.view.FLVPlayer;
	import com.lookmum.view.Slider;
	import com.lookmum.view.ToggleButton;
	import com.lookmum.view.VolumeSlider;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	[Event(name = 'end', type = 'com.lookmum.events.MediaPlayerEvent')]

	public class VideoPlayer extends Component implements IMediaPlayer
	{
		
		protected var mediaPlayer:IMediaPlayer;
		protected var videoSlider:VideoSlider;
		protected var volumeSlider:VolumeSlider;
		protected var buttonPlayPause:ToggleButton;
		protected var buttonRewind:Button;
		protected var buttonFastForward:Button;
		protected var buttonMute:ToggleButton;
		protected var _playing:Boolean;
		protected var _autoRewind:Boolean = true;
		private var videoSliderDisabled:Boolean;
		protected var _isComplete:Boolean;
		protected var playIcon:Button;
		protected var loadIcon:MovieClip;
		protected var textFieldTime:TextField;
		private var _mediaClickPlayPause:Boolean;
		private var soundManager:SoundManager;
		
		public function VideoPlayer(target:MovieClip) 
		{
			super(target);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			mediaPlayer = getMediaPlayer();
			mediaPlayer.addEventListener(MediaPlayerEvent.UPDATE, onUpdate);
			mediaPlayer.addEventListener(MediaPlayerEvent.END, onEnd);
			mediaPlayer.addEventListener(MediaPlayerEvent.LOAD_PROGRESS, onLoadProgress);
			mediaPlayer.addEventListener(MediaPlayerEvent.BUFFER_EMPTY, onBufferEmpty);
			mediaPlayer.addEventListener(MediaPlayerEvent.BUFFER_FULL, onBufferFull);
			volumeSlider = getVolumeSlider();
			if (volumeSlider)
			{
			}
			buttonRewind = getButtonRewind()
			if (buttonRewind)
			{
				buttonRewind.addEventListener(MouseEvent.CLICK, onRewind);
			}
			buttonFastForward = getButtonFastForward();
			if (buttonFastForward)
			{
				buttonFastForward.addEventListener(MouseEvent.CLICK, onFastForward);
			}
			videoSlider = getSlider();
			if (videoSlider)
			{
				videoSlider.addEventListener(DragEvent.START, onStartDragSlider);
				videoSlider.addEventListener(DragEvent.DRAG, onDragSlider);
				videoSlider.addEventListener(DragEvent.STOP, onStopDragSlider);
			}
			buttonPlayPause = getButtonPlayPause();
			if (buttonPlayPause)
			{
				buttonPlayPause.addEventListener(MouseEvent.CLICK, onReleaseButtonPlayPause);
			}
			buttonMute = getButtonMute();
			if (buttonMute)
			{
				buttonMute.addEventListener(MouseEvent.CLICK, onReleaseButtonMute);
				soundManager = SoundManager.getInstance();
				soundManager.addEventListener(Event.CHANGE, onChangeVolume);
				buttonMute.toggle = soundManager.mute;
			}
			playIcon = getPlayIcon();
			if (playIcon) {
				playIcon.addEventListener(MouseEvent.CLICK, onReleasePlayIcon);
			}
			loadIcon = getLoadIcon();
			if (loadIcon) {
				loadIcon.visible = false;
			}
			textFieldTime = getTextFieldTime();
			
		}
		
		public function setSmoothing(value:Boolean):void {
			FLVPlayer(mediaPlayer).setSmoothing(value);
		}
		
		protected function onBufferFull(e:MediaPlayerEvent):void 
		{
			if (loadIcon){
				loadIcon.visible = false;
			}
		}
		
		protected function onBufferEmpty(e:MediaPlayerEvent):void 
		{
			mediaPlayer.bufferTime *= 2
			if (loadIcon && duration - time > 1) {
				loadIcon.visible = true;
			}
		}
		
		protected function onLoadProgress(e:MediaPlayerEvent):void 
		{
			var loaded:Number = mediaPlayer.loadLevel;
			if (!isNaN(loaded) && loaded <= 1 && videoSlider){
				videoSlider.loadLevel = loaded;
			}
			/*if (e.bytesLoaded > 0 && loadIcon && loadIcon.visible) {
				loadIcon.visible = false;
			}*/
		}
		
		private function onReleasePlayIcon(e:MouseEvent):void 
		{
			play();
		}
			
		private function onFastForward(e:MouseEvent):void 
		{
			pause();
			if (_autoRewind)
			{
				seek(0);
			}else {
				seek(duration);
			}
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.END));
		}
		
		protected function onRewind(e:MouseEvent):void 
		{
			isComplete = false;
			seek(0);
			play();
		}
		override public function get visible():Boolean { return super.visible; }
		
		override public function set visible(value:Boolean):void 
		{
			super.visible = value;
			//if (!value) pause();
		}
		
		protected function getMediaPlayer():IMediaPlayer
		{
			return new FLVPlayer(target.getChildByName('flvPlayer') as MovieClip);
		}
		
		protected function getSlider():VideoSlider
		{
			if (!target.getChildByName('videoSlider')) return null;
			return new VideoSlider(target.getChildByName('videoSlider') as MovieClip);
		}
		
		protected function getButtonPlayPause():ToggleButton
		{
			if (!target.getChildByName('buttonPlayPause')) return null;
			return new ToggleButton(target.getChildByName('buttonPlayPause') as MovieClip);
		}
		
		protected function getButtonMute():ToggleButton 
		{
			if (!target.getChildByName('buttonMute')) return null;
			return new ToggleButton(target.getChildByName('buttonMute') as MovieClip);	
		}
		protected function getButtonRewind():Button
		{
			if (!target.getChildByName('buttonRewind')) return null;
			return new Button(target.getChildByName('buttonRewind') as MovieClip);
		}
		
		protected function getButtonFastForward():Button
		{
			if (!target.getChildByName('buttonFastForward')) return null;
			return new Button(target.getChildByName('buttonFastForward') as MovieClip);
		}
		protected function getVolumeSlider():VolumeSlider
		{
			if (!target.getChildByName('volumeSlider')) return null;
			return new VolumeSlider(target.getChildByName('volumeSlider') as MovieClip);
		}
		protected function getPlayIcon():Button 
		{
			if (!target.getChildByName('playIcon')) return null;
			return new Button(target.getChildByName('playIcon') as MovieClip);
		}
		protected function getLoadIcon():MovieClip 
		{
			if (!target.getChildByName('loadIcon')) return null;
			return target.getChildByName('loadIcon') as MovieClip;
		}
		protected function getTextFieldTime():TextField 
		{
			if (!target.getChildByName('textFieldTime')) return null;
			return target.getChildByName('textFieldTime') as TextField;
		}
		
		protected function onEnd(e:MediaPlayerEvent):void 
		{
			if (videoSlider && videoSlider.getIsDragging()) return;
			
			isComplete = true;
			if (buttonPlayPause) buttonPlayPause.toggle = true;
			_playing = false;
			if (_autoRewind)
			{
				seek(0);
			}
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.STOP));
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.END));
		}
		/**
		 * Disable the slider and flag it as not included in enabling/disabling children
		 */
		public function disableSlider():void
		{
			if (videoSlider)
			{
				videoSlider.enabled = false;
				videoSliderDisabled = true;
			}
		}
		
		protected function onStartDragSlider(e:DragEvent):void 
		{
			mediaPlayer.pause();
		}
		protected function onDragSlider(e:DragEvent):void 
		{
			//mediaPlayer.seek(mediaPlayer.duration * videoSlider.level);
			seek(mediaPlayer.duration * videoSlider.level);
		}
		protected function onStopDragSlider(e:DragEvent):void 
		{
			e.preventDefault();
			if (!_playing) return;
			mediaPlayer.play();
		}
		
		protected function onReleaseButtonPlayPause(e:MouseEvent):void 
		{
			if (_playing)
			{
				pause();
			}
			else 
			{
				play();
			}
			
			if (isComplete)
			{
				isComplete = false;
				seek(0);
				play();
			}
			if (buttonPlayPause) buttonPlayPause.toggle = !playing;
		}
		
		protected function onReleaseButtonMute(e:MouseEvent):void 
		{
			soundManager.mute = buttonMute.toggle;
		}
		private function onChangeVolume(e:Event):void 
		{
			buttonMute.toggle = soundManager.level == 0;
		}
		protected function onUpdate(e:MediaPlayerEvent):void 
		{
			if (videoSlider)
			{
				if (!videoSlider.getIsDragging())
				{
					var level:Number = mediaPlayer.time / mediaPlayer.duration;
					if (!isNaN(level) && level <= 1)
						videoSlider.level = level;
				}
			}
			
			if (textFieldTime) 
			{
				var timeText:String = getTimeText();
				textFieldTime.text = timeText;
			}
			
			dispatchEvent(e.clone());
		}
		protected function getTimeText():String {
			var ms:int = mediaPlayer.time * 1000;
			var timeText:String = TimeCodeUtil.toTimeCode(ms);
			return timeText;
		}
		public function load(url:String, autoPlay:Boolean = true):void
		{
			bufferTime = 1;
			isComplete = false;
			if (videoSlider) videoSlider.level = (0);
			if (loadIcon) loadIcon.visible = true;
			_playing = autoPlay;
			mediaPlayer.load(url, autoPlay);
			if (buttonPlayPause) buttonPlayPause.toggle = (!autoPlay);
			if (autoPlay) {
				if (playIcon) {
					playIcon.visible = false;
				}
				dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAY));
			}else {
				if (playIcon) {
					playIcon.visible = true;
				}
			}
		}
		
		override public function play():void
		{
			if (playIcon) {
				playIcon.visible = false;
			}
			_playing = true;
			mediaPlayer.play();
			if (buttonPlayPause) buttonPlayPause.toggle = (false);
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.PLAY));
		}
		
		public function pause():void
		{
			_playing = false;
			mediaPlayer.pause();
			if (buttonPlayPause) buttonPlayPause.toggle = (true);
			dispatchEvent(new MediaPlayerEvent(MediaPlayerEvent.STOP));
		}
		
		public function get playing():Boolean
		{
			return mediaPlayer.playing;
		}
		
		public function get time():Number
		{
			return mediaPlayer.time;
		}
		
		public function seek(time:Number):void
		{
			mediaPlayer.seek(time);
			if (videoSlider && !videoSlider.getIsDragging()) videoSlider.level = (time / mediaPlayer.duration);
			if (textFieldTime) {
				var timeText:String = getTimeText();
				textFieldTime.text = timeText;
			}
		}
		
		public function get loadLevel():Number{
			return mediaPlayer.loadLevel;
		}
		public function get duration():Number
		{
			return mediaPlayer.duration;
		}
		public function clear():void
		{
			if(videoSlider)videoSlider.level = (0);
			mediaPlayer.clear();
			if (buttonPlayPause) buttonPlayPause.toggle = (true);
		}
		public function get bufferTime():Number {
			return mediaPlayer.bufferTime;
		}
		
		public function set bufferTime(value:Number):void 
		{
			mediaPlayer.bufferTime = (value);
		}
		
		public function get autoRewind():Boolean {
			return _autoRewind;
		}
		
		public function set autoRewind(value:Boolean):void 
		{
			_autoRewind = value;
		}
		override public function get enabled():Boolean { return videoSlider.enabled; }
		
		override public function set enabled(value:Boolean):void 
		{
			if (videoSlider) videoSlider.enabled = value;
			if (buttonPlayPause) buttonPlayPause.enabled = value;
			if (buttonRewind) buttonRewind.enabled = value;
			if (buttonFastForward) buttonFastForward.enabled = value;
			if (volumeSlider) volumeSlider.enabled = value;
		}
		
		public function get isComplete():Boolean { return _isComplete; }
		
		public function set isComplete(value:Boolean):void 
		{
			_isComplete = value;
		}
		
		public function get mediaClickPlayPause():Boolean 
		{
			return _mediaClickPlayPause;
		}
		
		public function set mediaClickPlayPause(value:Boolean):void 
		{
			_mediaClickPlayPause = value;
			if (value) {
				mediaPlayer.addEventListener(MouseEvent.CLICK, onReleaseButtonPlayPause);
			}else {
				mediaPlayer.removeEventListener(MouseEvent.CLICK, onReleaseButtonPlayPause);
			}
		}
		
		public function get autoStopOnInvisible():Boolean 
		{
			if(mediaPlayer is FLVPlayer){
				return FLVPlayer(mediaPlayer).autoStopOnInvisible;
			}else {
				return false;
			}
		}
		
		public function set autoStopOnInvisible(value:Boolean):void 
		{
			if(mediaPlayer is FLVPlayer){
				FLVPlayer(mediaPlayer).autoStopOnInvisible = value;
			}
		}
	}
	
}
