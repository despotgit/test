
package com.aem.utils
{

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import PixelPerfectCollisionDetection;

    /**
     * Wraps PixelPerfectCollisionDetection and hitTestObject in a single
     * convenient interface.
     *
     * @author Alexander Schearer <aschearer@gmail.com>
     */
    public class HitTest
    {

        public static function intersects(one:DisplayObject,
                two:DisplayObject, 
                parent:DisplayObjectContainer):Boolean
        {
            return one.hitTestObject(two) &&
               PixelPerfectCollisionDetection.isColliding(one, two, parent, true);
        }
    }
}
