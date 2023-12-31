package mxhx.macros;

import fixtures.TestBuildMacro;
import fixtures.TestBuildMacroFieldOnClass;
import fixtures.TestBuildMacroMXHXSuperclass;
import fixtures.TestBuildMacroNested;
import fixtures.TestBuildMacroObjectBaseClass;
import utest.Assert;
import utest.Test;

class MXHXComponentBuildMacroTest extends Test {
	public function testBuildMacro():Void {
		var result = new TestBuildMacro();
		Assert.equals(123.4, result.float);
	}

	public function testBuildMacroNested():Void {
		var result = new TestBuildMacroNested();
		Assert.notNull(result.nested);
		Assert.isOfType(result.nested, TestBuildMacro);
	}

	public function testBuildMacroObjectBaseClass():Void {
		var result = new TestBuildMacroObjectBaseClass();
		Assert.pass();
	}

	public function testBuildMacroFieldOnClass():Void {
		var result = new TestBuildMacroFieldOnClass();
		Assert.equals("hello", result.customField);
	}

	public function testBuildMacroMXHXSuperclass():Void {
		var result = new TestBuildMacroMXHXSuperclass();
		Assert.equals(123.4, result.float);
		Assert.equals(567.8, result.float2);
	}
}
