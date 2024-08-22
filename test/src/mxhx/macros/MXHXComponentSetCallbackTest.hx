package mxhx.macros;

import fixtures.TestCallbacksClass;
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

	public function testSetCallbackSetAnyFunction():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestCallbacksClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="theTarget"/>
				</mx:Declarations>
				<tests:mapToAny>
					<mx:SetCallback target="theTarget" property="propName"/>
				</tests:mapToAny>
			</tests:TestCallbacksClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestCallbacksClass);
		var strictResult = cast(result, TestCallbacksClass);
		var callback = strictResult.mapToAny;
		Assert.notNull(callback);
		Assert.isTrue(Reflect.isFunction(callback));

		var theTarget = result.theTarget;
		Assert.notNull(theTarget);
		Assert.isNull(Reflect.getProperty(theTarget, "propName"));

		var callbackValue = "newValue";
		var callbackResult = Reflect.callMethod(null, callback, [callbackValue]);
		Assert.equals("newValue", callbackResult);
		Assert.equals("newValue", Reflect.getProperty(theTarget, "propName"));
	}

	public function testSetCallbackSimpleFunction():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestCallbacksClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<mx:Struct id="theTarget"/>
				</mx:Declarations>
				<tests:simpleFunction>
					<mx:SetCallback target="theTarget" property="propName"/>
				</tests:simpleFunction>
			</tests:TestCallbacksClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestCallbacksClass);
		var strictResult = cast(result, TestCallbacksClass);
		var callback = strictResult.simpleFunction;
		Assert.notNull(callback);
		Assert.isTrue(Reflect.isFunction(callback));

		var theTarget = result.theTarget;
		Assert.notNull(theTarget);
		Assert.isNull(Reflect.getProperty(theTarget, "propName"));

		var callbackValue = "newValue";
		var callbackResult = Reflect.callMethod(null, callback, [callbackValue]);
		Assert.equals("newValue", callbackResult);
		Assert.equals("newValue", Reflect.getProperty(theTarget, "propName"));
	}
}
