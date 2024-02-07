package mxhx.runtime;

import mxhx.runtime.MXHXRuntimeComponent.MXHXRuntimeComponentException;
import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentDesignLayerTest extends Test {
	public function testLibraryEmpty():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:DesignLayer></mx:DesignLayer>
			</mx:Object>
		'), MXHXRuntimeComponentException);
	}
}
