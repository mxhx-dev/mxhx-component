package mxhx.runtime;

import mxhx.runtime.MXHXRuntimeComponent.MXHXRuntimeComponentException;
import utest.Assert;
import utest.Test;

// some sanity tests for invalid XML or unresolvable symbols
// however, better to put most tests in mxhx-parser and mxhx-resolver
class MXHXRuntimeComponentInvalidXmlTest extends Test {
	public function testMissingCloseTag():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
		'), MXHXRuntimeComponentException);
	}

	public function testMissingXmlns():Void {
		Assert.raises(() -> MXHXRuntimeComponent.withMarkup('
			<mx:Object/>
		'), MXHXRuntimeComponentException);
	}
}
