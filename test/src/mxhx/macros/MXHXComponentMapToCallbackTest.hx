package mxhx.macros;

import utest.Assert;
import utest.Test;

class MXHXComponentMapToCallbackTest extends Test {
	public function testMapToCallbackDeclarations():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Declarations>
					<mx:MapToCallback id="callback" property="propName"/>
				</mx:Declarations>
			</mx:Object>
		');
		Assert.notNull(result);
		Assert.notNull(result.callback);
		Assert.isTrue(Reflect.isFunction(result.callback));

		var callbackValue = {propName: "propValue"};
		var callbackResult = result.callback(callbackValue);
		Assert.equals("propValue", callbackResult);
	}

	public function testMapToCallbackProperty():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
				<mx:Declarations>
				</mx:Declarations>
				<mx:mapToCallbackProp>
					<mx:MapToCallback property="propName"/>
				</mx:mapToCallbackProp>
			</mx:Object>
		');
		Assert.notNull(result);
		Assert.notNull(result.mapToCallbackProp);
		Assert.isTrue(Reflect.isFunction(result.mapToCallbackProp));

		var callbackValue = {propName: "propValue"};
		var callbackResult = result.mapToCallbackProp(callbackValue);
		Assert.equals("propValue", callbackResult);
	}
}
