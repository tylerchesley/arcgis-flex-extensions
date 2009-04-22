package org.tylerchesley.esri.controls
{
    import com.esri.ags.Map;
    import com.esri.ags.events.ExtentEvent;
    import com.esri.ags.toolbars.Navigation;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import mx.controls.Button;
    import mx.core.Container;
    import mx.core.ScrollPolicy;
    
    //--------------------------------------
    //  Styles
    //--------------------------------------
    
    [Style(name="panDownButtonStyleName", type="String")]
    
    [Style(name="panLeftButtonStyleName", type="String")]
    
    [Style(name="panRightButtonStyleName", type="String")]
    
    [Style(name="panUpButtonStyleName", type="String")]
    
    [Style(name="nextExtentButtonStyleName", type="String")]
    
    [Style(name="previousExtentButtonStyleName", type="String")]
    
    /**
    * 
    * 
    * 
    * @author Tyler Chesley
    */
    public class ExtentControl extends Container
    {
        
    //------------------------------------------------------------------------------
    //  Constructor
    //------------------------------------------------------------------------------
        
        public function ExtentControl()
        {
            super();
            
            navigation = new Navigation(map);
            navigation.addEventListener(ExtentEvent.EXTENT_CHANGE, 
                                        extentChangeHandler);
            
            horizontalScrollPolicy = ScrollPolicy.OFF;
            verticalScrollPolicy   = ScrollPolicy.OFF;
        }
    
    //------------------------------------------------------------------------------
    //  Variables
    //------------------------------------------------------------------------------
        
        protected var panDown:Button;
        
        protected var panLeft:Button;
        
        protected var panRight:Button;
        
        protected var panUp:Button;
        
        protected var previousExtent:Button;
        
        protected var nextExtent:Button;
        
        protected var navigation:Navigation = new Navigation();
    
    //------------------------------------------------------------------------------
    //  Properties
    //------------------------------------------------------------------------------
        
        private var _map:Map;
        
        [Bindable('mapChanged')]
        
        public function get map():Map
        {
            return _map;
        }
        
        public function set map(value:Map):void
        {
            if (_map !== value)
            {
                _map = value;
                navigation.map = value;
                
                dispatchEvent(new Event('mapChanged'));
            }
        }
        
    //------------------------------------------------------------------------------
    //  Overriden Methods
    //------------------------------------------------------------------------------
        
        override protected function createChildren():void
        {
            super.createChildren();
            
            if (!panDown)
            {
                panDown = new Button();
                panDown.toolTip = 'Pan Down';
                panDown.styleName = getStyle('panDownButtonStyleName');
                panDown.addEventListener(MouseEvent.CLICK, panHandler);
                addChild(panDown);
            }
            
            if (!panLeft)
            {
                panLeft = new Button();
                panLeft.toolTip = 'Pan Left';
                panLeft.styleName = getStyle('panLeftButtonStyleName');
                panLeft.addEventListener(MouseEvent.CLICK, panHandler);
                addChild(panLeft);
            }
            
            if (!panRight)
            {
                panRight = new Button();
                panRight.toolTip = 'Pan Right';
                panRight.styleName = getStyle('panRightButtonStyleName');
                panRight.addEventListener(MouseEvent.CLICK, panHandler);
                addChild(panRight);
            }
            
            if (!panUp)
            {
                panUp = new Button();
                panUp.toolTip = 'Pan Up';
                panUp.styleName = getStyle('panUpButtonStyleName');
                panUp.addEventListener(MouseEvent.CLICK, panHandler);
                addChild(panUp);
            }
            
            if (!nextExtent)
            {
                nextExtent = new Button();
                nextExtent.toolTip = 'Next Extent';
                nextExtent.enabled = !navigation.isLastExtent;
                nextExtent.styleName = getStyle('nextExtentButtonStyleName');
                nextExtent.addEventListener(MouseEvent.CLICK, extentHandler);
                addChild(nextExtent);
            }
            
            if (!previousExtent)
            {
                previousExtent = new Button();
                previousExtent.toolTip = 'Previous Extent';
                previousExtent.enabled = !navigation.isFirstExtent;
                previousExtent.styleName = getStyle('previousExtentButtonStyleName');
                previousExtent.addEventListener(MouseEvent.CLICK, extentHandler);
                addChild(previousExtent);
            }
        }
        
        override protected function measure():void
        {
            measuredWidth  = measuredMinWidth  = 50;
            measuredHeight = measuredMinHeight = 50;
        }
        
        override public function styleChanged(styleProp:String):void
        {
            super.styleChanged(styleProp);
            
            
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, 
                                                      unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            var h:Number = unscaledHeight / 3;
            var cW:Number = unscaledWidth / 4;
            var w:Number = cW * 2;
            var sX:Number = unscaledWidth / 2 - w / 2;
            
            /* Layout the top section */
            
            panUp.x = sX;
            panUp.width = w;
            panUp.height = h;
            
            /* Layout the center section */
            
            var cX:Number = 0;
            
            panLeft.x = cX;
            panLeft.y = h;
            panLeft.width = cW;
            panLeft.height = h;
            
            previousExtent.x = cX = cX + cW;
            previousExtent.y = h;
            previousExtent.width = cW;
            previousExtent.height = h;
            
            nextExtent.x = cX = cX + cW;
            nextExtent.y = h;
            nextExtent.width = cW;
            nextExtent.height = h;
            
            panRight.x = cX + cW;
            panRight.y = h;
            panRight.width = cW;
            panRight.height = h;
            
            /* Layout the bottom section */
            
            panDown.x = sX;
            panDown.y = h + h;
            panDown.width = w;
            panDown.height = h;
        }
    
    //------------------------------------------------------------------------------
    //  Event Handlers
    //------------------------------------------------------------------------------
        
        protected function extentHandler(event:MouseEvent):void
        {
            if (!navigation)
            {
                return;
            }
            
            if (event.target == nextExtent)
            {
                navigation.zoomToNextExtent();
            }
            else if (event.target == previousExtent)
            {
                navigation.zoomToPrevExtent();
            }
        }
        
        protected function extentChangeHandler(event:ExtentEvent):void
        {
            nextExtent.enabled = !navigation.isLastExtent;
            previousExtent.enabled = !navigation.isFirstExtent;
        }
        
        protected function panHandler(event:MouseEvent):void
        {
            if (!map)
            {
                return;
            }
            
            switch (event.target)
            {
                case panDown: 
                {
                    map.panDown();
                    break;
                }
                
                case panLeft:
                {
                    map.panLeft();
                    break;
                }
                
                case panRight:
                {
                    map.panRight();
                    break;
                }
                
                case panUp:
                {
                    map.panUp();
                    break;
                }
            }
            
            
        }
        
    }
}