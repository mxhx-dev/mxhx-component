package mxhx.runtime;

import fixtures.ArrayCollection;
import utest.Assert;
import utest.Test;

class MXHXRuntimeComponentArrayCollectionTest extends Test {
	public function testSetArrayPropertyArrayWrapperExplicitType():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
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
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("collection"));
		var collection = Std.downcast((idMap.get("collection") : Dynamic), ArrayCollection);
		Assert.notNull(collection);
		Assert.notNull(collection.array);
		Assert.equals(3, collection.array.length);
		Assert.equals("One", collection.array[0]);
		Assert.equals("Two", collection.array[1]);
		Assert.equals("Three", collection.array[2]);
	}

	public function testSetArrayPropertyArrayWrapperInferredType():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
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
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("collection"));
		var collection = Std.downcast((idMap.get("collection") : Dynamic), ArrayCollection);
		Assert.notNull(collection);
		Assert.notNull(collection.array);
		Assert.equals(3, collection.array.length);
		Assert.equals("One", collection.array[0]);
		Assert.equals("Two", collection.array[1]);
		Assert.equals("Three", collection.array[2]);
	}

	public function testSetArrayPropertyInferredType():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
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
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("collection"));
		var collection = Std.downcast((idMap.get("collection") : Dynamic), ArrayCollection);
		Assert.notNull(collection);
		Assert.notNull(collection.array);
		Assert.equals(3, collection.array.length);
		Assert.equals("One", collection.array[0]);
		Assert.equals("Two", collection.array[1]);
		Assert.equals("Three", collection.array[2]);
	}

	public function testSetDefaultPropertyArrayWrapperExplicitType():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
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
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("collection"));
		var collection = Std.downcast((idMap.get("collection") : Dynamic), ArrayCollection);
		Assert.notNull(collection);
		Assert.notNull(collection.array);
		Assert.equals(3, collection.array.length);
		Assert.equals("One", collection.array[0]);
		Assert.equals("Two", collection.array[1]);
		Assert.equals("Three", collection.array[2]);
	}

	public function testSetDefaultPropertyArrayWrapperInferredType():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
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
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("collection"));
		var collection = Std.downcast((idMap.get("collection") : Dynamic), ArrayCollection);
		Assert.notNull(collection);
		Assert.notNull(collection.array);
		Assert.equals(3, collection.array.length);
		Assert.equals("One", collection.array[0]);
		Assert.equals("Two", collection.array[1]);
		Assert.equals("Three", collection.array[2]);
	}

	public function testSetDefaultPropertyInferredType():Void {
		var idMap:Map<String, Any> = [];
		var result = MXHXRuntimeComponent.withMarkup('
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
		', idMap);
		Assert.notNull(result);
		Assert.isTrue(idMap.exists("collection"));
		var collection = Std.downcast((idMap.get("collection") : Dynamic), ArrayCollection);
		Assert.notNull(collection);
		Assert.notNull(collection.array);
		Assert.equals(3, collection.array.length);
		Assert.equals("One", collection.array[0]);
		Assert.equals("Two", collection.array[1]);
		Assert.equals("Three", collection.array[2]);
	}
}
