package mxhx.macros;

import utest.Assert;
import utest.Test;

class MXHXComponentSetCallbackTest extends Test {
	public function testSetCallbackDeclarations():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Declarations>
					<mx:Struct id="theTarget"/>
					<mx:SetCallback id="callback" target="theTarget" property="propName"/>
				</mx:Declarations>
			</mx:Object>
		');
		Assert.notNull(result);
		Assert.notNull(result.callback);
		Assert.isTrue(Reflect.isFunction(result.callback));
		Assert.notNull(result.theTarget);
		Assert.isNull(result.theTarget.propName);

		var callbackValue = "newValue";
		var callbackResult = result.callback(callbackValue);
		Assert.equals("newValue", callbackResult);
		Assert.equals("newValue", result.theTarget.propName);
	}

	public function testSetCallbackProperty():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Declarations>
					<mx:Struct id="theTarget"/>
				</mx:Declarations>
				<mx:setCallbackProp>
					<mx:SetCallback target="theTarget" property="propName"/>
				</mx:setCallbackProp>
			</mx:Object>
		');
		Assert.notNull(result);
		Assert.notNull(result.setCallbackProp);
		Assert.isTrue(Reflect.isFunction(result.setCallbackProp));
		Assert.notNull(result.theTarget);
		Assert.isNull(result.theTarget.propName);

		var callbackValue = "newValue";
		var callbackResult = result.setCallbackProp(callbackValue);
		Assert.equals("newValue", callbackResult);
		Assert.equals("newValue", result.theTarget.propName);
	}
}
