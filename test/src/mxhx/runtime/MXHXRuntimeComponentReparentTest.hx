package mxhx.runtime;

import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentReparentTest extends Test {
	public function testReparent():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Reparent/>
			</mx:Object>
		'), haxe.Exception);
	}
}
