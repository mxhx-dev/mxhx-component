package mxhx.macros;

import fixtures.TestClass1;
import fixtures.TestInlineComponentClassAbstractFromClass.Underlying;
import utest.Assert;
import utest.Test;

class MXHXComponentInlineComponentTest extends Test {
	public function testInlineComponentForPropertyOfTypeClass():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestInlineComponentClass xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:classProperty>
					<mx:Component>
						<tests:TestClass1/>
					</mx:Component>
				</tests:classProperty>
			</tests:TestInlineComponentClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.classProperty, Class);
		Assert.equals(TestClass1, Type.getSuperClass(result.classProperty));
		var instance:Dynamic = Type.createInstance(result.classProperty, []);
		Assert.equals(result, instance.outerDocument);
	}

	public function testInlineComponentForPropertyOfTypeAbstractFromClass():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestInlineComponentClassAbstractFromClass xmlns:mx="https://ns.mxhx.dev/2024/basic" xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<tests:classAbstractProperty>
					<mx:Component>
						<tests:TestClass1/>
					</mx:Component>
				</tests:classAbstractProperty>
			</tests:TestInlineComponentClassAbstractFromClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.classAbstractProperty, Underlying);
		var underlying:Underlying = result.classAbstractProperty;
		Assert.isOfType(underlying.c, Class);
		Assert.equals(TestClass1, Type.getSuperClass(underlying.c));
		var instance:Dynamic = Type.createInstance(underlying.c, []);
		Assert.equals(result, instance.outerDocument);
	}
}
