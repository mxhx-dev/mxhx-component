package mxhx.runtime;

import mxhx.runtime.MXHXRuntimeComponent.MXHXRuntimeComponentException;
import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentFullNamespaceTest extends Test {
	public function testException():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/mxhx">
				<mx:Declarations>
					<mx:String id="string">hello</mx:String>
				</mx:Declarations>
			</mx:Object>
		'), MXHXRuntimeComponentException);
	}
}
