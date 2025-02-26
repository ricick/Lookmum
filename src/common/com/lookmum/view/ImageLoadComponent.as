package com.lookmum.view 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author 
	 */
	public class ImageLoadComponent extends Component
	{
		protected var bitmap:Bitmap;
		protected var loader:Loader;
		
		public var containsImage:Boolean;
		protected var imageLoaderInfo:LoaderInfo;
			
		public function ImageLoadComponent(target:MovieClip) 
		{
			super(target);
			containsImage = false;	
			loader = new Loader();		
		}
		
		public function load(imageURI:String, context:LoaderContext = null ):void {
			if (containsImage) clearImage();
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(new URLRequest(imageURI), context);
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			trace(e);
		}
		
		protected function onProgress(e:ProgressEvent):void 
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}
		
		public function clearImage():void {
			if (containsImage)
				target.removeChild(loader);
			containsImage = false;
		}
		public function setSmoothing(value:Boolean):void {
			if (!containsImage) return;
			bitmap.smoothing = value;
		}
		private function onCompleteLoad(e:Event):void 
		{
			containsImage = true;
			imageLoaderInfo = e.target as LoaderInfo;
			bitmap = loader.content as Bitmap;
			target.addChild(loader);			
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteLoad);
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}	
}