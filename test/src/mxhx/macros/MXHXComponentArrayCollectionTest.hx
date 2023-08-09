package mxhx.macros;

import fixtures.ArrayCollection;
import utest.Assert;
import utest.Test;

class MXHXComponentArrayCollectionTest extends Test {
	public function testSetArrayPropertyArrayWrapperExplicitType():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:ArrayCollection id="collection">
						<tests:array>
							<mx:Array type="String">
								<mx:String>One</mx:String>
								<mx:String>Two</mx:String>
								<mx:String>Three</mx:String>
							</mx:Array>
						</tests:array>
					</tests:ArrayCollection>
				</mx:Declarations>
			</mx:Object>
		');
		Assert.notNull(result);
		Assert.notNull(result.collection);
		Assert.isOfType(result.collection, ArrayCollection);
		Assert.notNull(result.collection.array);
		Assert.equals(3, result.collection.array.length);
	}

	public function testSetArrayPropertyArrayWrappeInferredType():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:ArrayCollection id="collection">
						<tests:array>
							<mx:Array>
								<mx:String>One</mx:String>
								<mx:String>Two</mx:String>
								<mx:String>Three</mx:String>
							</mx:Array>
						</tests:array>
					</tests:ArrayCollection>
				</mx:Declarations>
			</mx:Object>
		');
		Assert.notNull(result);
		Assert.notNull(result.collection);
		Assert.isOfType(result.collection, ArrayCollection);
		Assert.notNull(result.collection.array);
		Assert.equals(3, result.collection.array.length);
	}

	public function testSetArrayPropertyInferredType():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:ArrayCollection id="collection">
						<tests:array>
							<mx:String>One</mx:String>
							<mx:String>Two</mx:String>
							<mx:String>Three</mx:String>
						</tests:array>
					</tests:ArrayCollection>
				</mx:Declarations>
			</mx:Object>
		');
		Assert.notNull(result);
		Assert.notNull(result.collection);
		Assert.isOfType(result.collection, ArrayCollection);
		Assert.notNull(result.collection.array);
		Assert.equals(3, result.collection.array.length);
	}

	public function testSetDefaultPropertyArrayWrapperExplicitType():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:ArrayCollection id="collection">
						<mx:Array type="String">
							<mx:String>One</mx:String>
							<mx:String>Two</mx:String>
							<mx:String>Three</mx:String>
						</mx:Array>
					</tests:ArrayCollection>
				</mx:Declarations>
			</mx:Object>
		');
		Assert.notNull(result);
		Assert.notNull(result.collection);
		Assert.isOfType(result.collection, ArrayCollection);
		Assert.notNull(result.collection.array);
		Assert.equals(3, result.collection.array.length);
	}

	public function testSetDefaultPropertyArrayWrapperInferredType():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:ArrayCollection id="collection">
						<mx:Array>
							<mx:String>One</mx:String>
							<mx:String>Two</mx:String>
							<mx:String>Three</mx:String>
						</mx:Array>
					</tests:ArrayCollection>
				</mx:Declarations>
			</mx:Object>
		');
		Assert.notNull(result);
		Assert.notNull(result.collection);
		Assert.isOfType(result.collection, ArrayCollection);
		Assert.notNull(result.collection.array);
		Assert.equals(3, result.collection.array.length);
	}

	public function testSetDefaultPropertyInferredType():Void {
		var result = MXHXComponent.withMarkup('
			<mx:Object
				xmlns:mx="https://ns.mxhx.dev/2024/basic"
				xmlns:tests="https://ns.mxhx.dev/2024/tests">
				<mx:Declarations>
					<tests:ArrayCollection id="collection">
						<mx:String>One</mx:String>
						<mx:String>Two</mx:String>
						<mx:String>Three</mx:String>
					</tests:ArrayCollection>
				</mx:Declarations>
			</mx:Object>
		');
		Assert.notNull(result);
		Assert.notNull(result.collection);
		Assert.isOfType(result.collection, ArrayCollection);
		Assert.notNull(result.collection.array);
		Assert.equals(3, result.collection.array.length);
	}
}
