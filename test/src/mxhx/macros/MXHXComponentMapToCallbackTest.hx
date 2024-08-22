package mxhx.macros;

import fixtures.TestCallbacksClass;
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

	public function testMapToCallbackAny():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestCallbacksClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:mapToAny>
					<mx:MapToCallback property="propName"/>
				</tests:mapToAny>
			</tests:TestCallbacksClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestCallbacksClass);
		var strictResult = cast(result, TestCallbacksClass);
		var callback = strictResult.mapToAny;
		Assert.notNull(callback);
		Assert.isTrue(Reflect.isFunction(callback));

		var callbackValue = {propName: 123.4};
		var callbackResult = Reflect.callMethod(null, callback, [callbackValue]);
		Assert.equals(123.4, callbackResult);
	}

	public function testMapToCallbackString():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestCallbacksClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:mapToString>
					<mx:MapToCallback property="propName"/>
				</tests:mapToString>
			</tests:TestCallbacksClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestCallbacksClass);
		var strictResult = cast(result, TestCallbacksClass);
		var callback = strictResult.mapToString;
		Assert.notNull(callback);
		Assert.isTrue(Reflect.isFunction(callback));

		var callbackValue = {propName: 123.4};
		var callbackResult = Reflect.callMethod(null, callback, [callbackValue]);
		Assert.equals("123.4", callbackResult);
	}

	public function testMapToCallbackSimpleFunction():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestCallbacksClass
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:simpleFunction>
					<mx:MapToCallback property="propName"/>
				</tests:simpleFunction>
			</tests:TestCallbacksClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result, TestCallbacksClass);
		var strictResult = cast(result, TestCallbacksClass);
		var callback = strictResult.simpleFunction;
		Assert.notNull(callback);
		Assert.isTrue(Reflect.isFunction(callback));

		var callbackValue = {propName: 123.4};
		var callbackResult = Reflect.callMethod(null, callback, [callbackValue]);
		Assert.equals(123.4, callbackResult);
	}
}
