package mxhx.runtime;

import mxhx.runtime.MXHXRuntimeComponent.MXHXRuntimeComponentException;
import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentBindingTagTest extends Test {
	public function testBindingException():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2024/mxhx" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:String id="string1">hello</mx:String>
					<mx:String id="string2"/>
					<tests:TestPropertiesClass id="strictlyTyped"/>
				</mx:Declarations>
				<mx:Binding source="string1" destination="string2"/>
			</tests:TestClass1>
		'), MXHXRuntimeComponentException);
	}
}
