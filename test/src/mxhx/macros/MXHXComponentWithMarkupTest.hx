package mxhx.macros;

import fixtures.TestBuildMacro;
import utest.Assert;
import utest.Test;

class MXHXComponentWithMarkupTest extends Test {
	public function testOuterDocument():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object xmlns:mx="https://ns.mxhx.dev/2024/basic">
			</mx:Object>
		');
		Assert.equals(this, result.outerDocument);
	}
}
