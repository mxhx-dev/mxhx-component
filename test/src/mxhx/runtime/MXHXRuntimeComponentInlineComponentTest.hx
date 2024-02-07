package mxhx.runtime;

import mxhx.runtime.MXHXRuntimeComponent.MXHXRuntimeComponentException;
import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentInlineComponentTest extends Test {
	public function testInlineComponentForPropertyOfTypeClass():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<tests:TestInlineComponentClass xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:classProperty>
					<mx:Component>
						<tests:TestClass1/>
					</mx:Component>
				</tests:classProperty>
			</tests:TestInlineComponentClass>
		'), MXHXRuntimeComponentException);
	}
}
