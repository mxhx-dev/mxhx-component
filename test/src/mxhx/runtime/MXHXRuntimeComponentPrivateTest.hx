package mxhx.runtime;

import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentPrivateTest extends Test {
	public function testPrivateEmpty():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Private></mx:Private>
			</mx:Object>
		'), haxe.Exception);
	}
}
