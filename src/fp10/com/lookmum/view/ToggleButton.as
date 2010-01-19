/**
* Description here..
* @author Default
* @version 0.1
*/
package com.lookmum.view{
	import com.lookmum.events.InteractiveComponentEvent;
	import com.lookmum.util.ModalManager;
	import com.lookmum.view.Button;
	import com.lookmum.view.IToggle;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class ToggleButton extends Button implements IToggle{

		protected const FRAME_ROLL_OVER_TOGGLE:String = 'rollOverToggle';
		protected const FRAME_ROLL_OUT_TOGGLE:String = 'rollOutToggle';
		protected const FRAME_PRESS_TOGGLE:String = 'pressToggle';
		protected const FRAME_DISABLE_TOGGLE:String = 'disableToggle';
		protected var _toggle:Boolean = false;
		public function ToggleButton(target:MovieClip) {
			super(target);
			addEventListener(MouseEvent.CLICK,onClick);
		}
		protected function onClick(event:MouseEvent):void {
			toggle = (!_toggle);
		}
		public function get toggle():Boolean{
			return _toggle;
		}
		public function set toggle(toggle:Boolean):void {
			_toggle = toggle;
			onRollOut(new MouseEvent(MouseEvent.CLICK));
		}
		override protected function onMouseUp(e:MouseEvent):void 
		{
			super.onMouseUp(e);
			if (!enabled) return;
			if (toggle) target.gotoAndStop(FRAME_ROLL_OVER_TOGGLE);
		}
		override protected function onMouseDown(e:MouseEvent):void 
		{
			super.onMouseDown(e);
			if (!enabled) return;
			if (toggle) target.gotoAndStop(FRAME_PRESS_TOGGLE);
		}
		override protected function onRollOver(e:MouseEvent):void 
		{
			super.onRollOver(e);
			if (!enabled) return;
			if (toggle) target.gotoAndStop(FRAME_ROLL_OVER_TOGGLE);
		}
		override protected function onRollOut(e:MouseEvent):void 
		{
			super.onRollOut(e);
			if (!enabled) return;
			if (toggle) target.gotoAndStop(FRAME_ROLL_OUT_TOGGLE);
		}
		override protected function doEnable():void 
		{
			super.doEnable();
			if (toggle) target.gotoAndStop(FRAME_ROLL_OUT_TOGGLE);
		}
		override protected function doDisable():void 
		{
			super.doDisable();
			if (toggle) target.gotoAndStop(FRAME_DISABLE_TOGGLE);
		}
	}
}