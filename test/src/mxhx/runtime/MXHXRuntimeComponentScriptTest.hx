package mxhx.runtime;

import mxhx.runtime.MXHXRuntimeComponent.MXHXRuntimeComponentException;
import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentScriptTest extends Test {
	public function testScriptEmpty():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Script></mx:Script>
			</mx:Object>
		'), MXHXRuntimeComponentException);
	}
}
