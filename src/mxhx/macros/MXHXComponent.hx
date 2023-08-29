/*
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
 */

package mxhx.macros;

#if macro
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.PositionTools;
import haxe.macro.Type.ClassType;
import mxhx.parser.MXHXParser;
import mxhx.resolver.IMXHXAbstractSymbol;
import mxhx.resolver.IMXHXClassSymbol;
import mxhx.resolver.IMXHXEnumFieldSymbol;
import mxhx.resolver.IMXHXEnumSymbol;
import mxhx.resolver.IMXHXEventSymbol;
import mxhx.resolver.IMXHXFieldSymbol;
import mxhx.resolver.IMXHXResolver;
import mxhx.resolver.IMXHXSymbol;
import mxhx.resolver.IMXHXTypeSymbol;
import mxhx.resolver.MXHXSymbolTools;
import sys.FileSystem;
import sys.io.File;
#end

/**
	Creates Haxe classes and instances at compile-time using
	[MXHX](https://mxhx.dev) markup.

	Pass an inline markup string to `MXHXComponent.withMarkup()` to create a
	component instance from the string. The following example creates a
	[Feathers UI](https://feathersui.com) component.

	```haxe
	var instance = MXHXComponent.withMarkup(
		'<f:LayoutGroup
			xmlns:mx="https://ns.mxhx.dev/2024/basic"
			xmlns:f="https://ns.feathersui.com/mxhx">
			<f:layout>
				<f:HorizontalLayout gap="10" horizontalAlign="RIGHT"/>
			</f:layout>
			<f:Button id="okButton" text="OK"/>
			<f:Button id="cancelButton" text="Cancel"/>
		</f:LayoutGroup>'
	);
	container.addChild(instance);
	container.okButton.addEventListener(TriggerEvent.TRIGGER, (event) -> {
		trace("triggered the OK button");
	});
	```

	Pass a file path (relative to the current _.hx_ source file) to
	`MXHXComponent.withFile()` to create a component instance from markup saved
	in an external file.

	```haxe
	var instance = MXHXComponent.withFile("path/to/MyClass.mxhx");
**/
class MXHXComponent {
	#if macro
	private static final FILE_PATH_TO_TYPE_DEFINITION:Map<String, TypeDefinition> = [];
	private static final LANGUAGE_URI_BASIC_2024 = "https://ns.mxhx.dev/2024/basic";
	private static final LANGUAGE_URI_FULL_2024 = "https://ns.mxhx.dev/2024/mxhx";
	private static final LANGUAGE_URIS = [
		// @:formatter:off
		LANGUAGE_URI_BASIC_2024,
		LANGUAGE_URI_FULL_2024,
		// @:formatter:on
	];
	private static final PACKAGE_RESERVED = ["mxhx", "_reserved"];
	private static final ATTRIBUTE_CLASS_NAME = "className";
	private static final ATTRIBUTE_DESTINATION = "destination";
	private static final ATTRIBUTE_IMPLEMENTS = "implements";
	private static final ATTRIBUTE_INCLUDE_IN = "includeIn";
	private static final ATTRIBUTE_ID = "id";
	private static final ATTRIBUTE_EXCLUDE_FROM = "excludeFrom";
	private static final ATTRIBUTE_SOURCE = "source";
	private static final ATTRIBUTE_TWO_WAY = "twoWay";
	private static final ATTRIBUTE_TYPE = "type";
	private static final ATTRIBUTE_XMLNS = "xmlns";
	private static final ATTRIBUTES_THAT_CAN_BE_UNRESOLVED = [
		// @:formatter:off
		ATTRIBUTE_ID,
		ATTRIBUTE_EXCLUDE_FROM,
		ATTRIBUTE_INCLUDE_IN,
		// @:formatter:on
	];
	private static final KEYWORD_THIS = "this";
	private static final KEYWORD_NEW = "new";
	private static final META_DEFAULT_XML_PROPERTY = "defaultXmlProperty";
	private static final META_ENUM = ":enum";
	private static final META_MARKUP = ":markup";
	private static final META_NO_COMPLETION = ":noCompletion";
	private static final TYPE_ANY = "Any";
	private static final TYPE_ARRAY = "Array";
	private static final TYPE_BOOL = "Bool";
	private static final TYPE_CLASS = "Class";
	private static final TYPE_DATE = "Date";
	private static final TYPE_DYNAMIC = "Dynamic";
	private static final TYPE_EREG = "EReg";
	private static final TYPE_FLOAT = "Float";
	private static final TYPE_FUNCTION = "Function";
	private static final TYPE_INT = "Int";
	private static final TYPE_NULL = "Null";
	private static final TYPE_STRING = "String";
	private static final TYPE_UINT = "UInt";
	private static final TYPE_VECTOR = "Vector";
	private static final TYPE_XML = "Xml";
	private static final TYPE_HAXE_FUNCTION = "haxe.Function";
	private static final TYPE_HAXE_CONSTRAINTS_FUNCTION = "haxe.Constraints.Function";
	private static final VALUE_TRUE = "true";
	private static final VALUE_FALSE = "false";
	private static final VALUE_NAN = "NaN";
	private static final VALUE_INFINITY = "Infinity";
	private static final VALUE_NEGATIVE_INFINITY = "-Infinity";
	private static final TAG_BINDING = "Binding";
	private static final TAG_COMPONENT = "Component";
	private static final TAG_DESIGN_LAYER = "DesignLayer";
	private static final TAG_DECLARATIONS = "Declarations";
	private static final TAG_DEFINITION = "Definition";
	private static final TAG_LIBRARY = "Library";
	private static final TAG_METADATA = "Metadata";
	private static final TAG_MODEL = "Model";
	private static final TAG_OBJECT = "Object";
	private static final TAG_PRIVATE = "Private";
	private static final TAG_REPARENT = "Reparent";
	private static final TAG_SCRIPT = "Script";
	private static final TAG_STRUCT = "Struct";
	private static final TAG_STYLE = "Style";
	private static final INIT_FUNCTION_NAME = "MXHXComponent_initMXHX";
	private static final FIELD_FULL_YEAR = "fullYear";
	private static final FIELD_MONTH = "month";
	private static final FIELD_DATE = "date";
	private static final FIELD_HOURS = "hours";
	private static final FIELD_MINUTES = "minutes";
	private static final FIELD_SECONDS = "seconds";
	private static final FIELD_OUTER_DOCUMENT = "outerDocument";
	private static final FIELD_DEFAULT_OUTER_DOCUMENT = "defaultOuterDocument";
	private static final LANGUAGE_MAPPINGS_2024 = [
		// @:formatter:off
		TYPE_ARRAY => TYPE_ARRAY,
		TYPE_BOOL => TYPE_BOOL,
		TYPE_CLASS => TYPE_CLASS,
		TYPE_DATE => TYPE_DATE,
		TYPE_EREG => TYPE_EREG,
		TYPE_FLOAT => TYPE_FLOAT,
		TYPE_FUNCTION => TYPE_HAXE_CONSTRAINTS_FUNCTION,
		TYPE_INT => TYPE_INT,
		TAG_OBJECT => TYPE_ANY,
		TYPE_STRING => TYPE_STRING,
		TAG_STRUCT => TYPE_DYNAMIC,
		TYPE_UINT => TYPE_UINT,
		TYPE_XML => TYPE_XML,
		// @:formatter:on
	];
	private static final LANGUAGE_TYPES_ASSIGNABLE_BY_TEXT = [
		// @:formatter:off
		TYPE_BOOL,
		TYPE_CLASS,
		TYPE_EREG,
		TYPE_FLOAT,
		TYPE_FUNCTION,
		TYPE_INT,
		TYPE_STRING,
		TYPE_UINT,
		// @:formatter:on
	];
	private static final ROOT_LANGUAGE_TAGS:Array<String> = [
		// @:formatter:off
		TAG_BINDING,
		TAG_DECLARATIONS,
		TAG_LIBRARY, // must be first child too
		TAG_METADATA,
		TAG_PRIVATE, // must be last child too
		TAG_REPARENT,
		TAG_SCRIPT,
		TAG_STYLE,
		// @:formatter:on
	];
	private static final UNSUPPORTED_LANGUAGE_TAGS:Array<String> = [
		// @:formatter:off
		TAG_DEFINITION,
		TAG_DESIGN_LAYER,
		TAG_LIBRARY,
		TAG_METADATA,
		TAG_PRIVATE,
		TAG_REPARENT,
		TAG_SCRIPT,
		TAG_STYLE,
		TYPE_VECTOR,
		// @:formatter:on
	];
	private static var componentCounter = 0;
	// float can hold larger integers than int
	private static var objectCounter:Float = 0.0;
	private static var posInfos:{min:Int, max:Int, file:String};
	private static var languageUri:String = null;
	private static var mxhxResolver:IMXHXResolver;
	private static var manifests:Map<String, Map<String, String>> = [];
	private static var dataBindingCallback:(Expr, Expr, Expr) -> Expr;
	private static var dispatchEventCallback:(Expr, String) -> Expr;
	private static var addEventListenerCallback:(Expr, String, Expr) -> Expr;
	#end

	/**
		Populates fields in a class using markup in a file. Similar to
		`withFile()`, but it's a build macro instead — which gives developers
		more control over the generated class. For instance, it's possible to
		define additional fields and methods to the class, and to instantiate it
		on demand.
	**/
	public macro static function build(?filePath:String):Array<Field> {
		var localClass = Context.getLocalClass().get();
		if (filePath == null) {
			filePath = localClass.name + ".mxhx";
		}
		var mxhxText = loadMXHXFile(filePath);
		posInfos = {file: filePath, min: 0, max: mxhxText.length};
		if (mxhxResolver == null) {
			createResolver();
		}
		var mxhxParser = new MXHXParser(mxhxText, posInfos.file);
		var mxhxData = mxhxParser.parse();
		if (mxhxData.problems.length > 0) {
			for (problem in mxhxData.problems) {
				reportError(problem.message, problem);
			}
			return null;
		}

		var superClass = localClass.superClass;
		var rootTag = mxhxData.rootTag;
		var resolvedTag = mxhxResolver.resolveTag(rootTag);
		var resolvedType:IMXHXTypeSymbol = null;
		if (resolvedTag != null && (resolvedTag is IMXHXTypeSymbol)) {
			resolvedType = cast resolvedTag;
		}
		if (resolvedType == null) {
			reportErrorForContextPosition('Could not resolve super class for \'${localClass.name}\' from tag \'<${rootTag.name}>\'', localClass.pos);
			return null;
		}
		if (!isObjectTag(rootTag)) {
			var expectedSuperClass = resolvedType.qname;
			if (superClass == null || Std.string(superClass.t) != expectedSuperClass) {
				reportErrorForContextPosition('Class ${localClass.name} must extend ${expectedSuperClass}', localClass.pos);
				return null;
			}
		}

		var buildFields = Context.getBuildFields();
		var localTypePath = {name: localClass.name, pack: localClass.pack};
		handleRootTag(mxhxData.rootTag, INIT_FUNCTION_NAME, localTypePath, buildFields);
		if (localClass.superClass != null) {
			var superClass = localClass.superClass.t.get();
			var initFunc = Lambda.find(buildFields, f -> f.name == INIT_FUNCTION_NAME);
			if (initFunc != null && needsOverrideMacro(initFunc.name, superClass)) {
				initFunc.access.push(AOverride);
				switch (initFunc.kind) {
					case FFun(f):
						var oldExpr = f.expr;
						f.expr = macro {
							super.$INIT_FUNCTION_NAME();
							$oldExpr;
						}
					default:
						reportError('Cannot find method ${INIT_FUNCTION_NAME} on class ${superClass.name}', rootTag);
				}
			}
		}
		return buildFields;
	}

	/**
		Instantiates a component from a file containing markup.

		Calling `withFile()` multiple times will re-use the same generated
		class each time.
	**/
	public macro static function withFile(filePath:String, ?typePath:TypePath):Expr {
		filePath = resolveFilePath(filePath);
		var typeDef:TypeDefinition = null;
		if (FILE_PATH_TO_TYPE_DEFINITION.exists(filePath)) {
			// for duplicate files, re-use the existing type definition
			typeDef = FILE_PATH_TO_TYPE_DEFINITION.get(filePath);
			if (typePath == null) {
				typePath = {name: typeDef.name, pack: typeDef.pack};
			}
		}
		if (typePath == null) {
			var name = 'MXHXComponent_${componentCounter}';
			componentCounter++;
			typePath = {name: name, pack: PACKAGE_RESERVED};
		}
		var outerDocumentTypePath:TypePath = null;
		if (typeDef == null) {
			var mxhxText = loadMXHXFile(filePath);
			posInfos = {file: filePath, min: 0, max: mxhxText.length};
			if (mxhxResolver == null) {
				createResolver();
			}
			var localClass = Context.getLocalClass().get();
			var localMethodName = Context.getLocalMethod();
			var localMethod = Lambda.find(localClass.statics.get(), field -> field.name == localMethodName);
			if (localMethod == null) {
				outerDocumentTypePath = {name: localClass.name, pack: localClass.pack};
			}
			typeDef = createTypeDefinitionFromString(mxhxText, typePath, outerDocumentTypePath);
			if (typeDef == null) {
				return macro null;
			}
			FILE_PATH_TO_TYPE_DEFINITION.set(filePath, typeDef);
			Context.defineType(typeDef);
		}
		if (outerDocumentTypePath != null) {
			var staticOuterDocumentFieldName = '${typeDef.name}_${FIELD_DEFAULT_OUTER_DOCUMENT}';
			var staticOuterDocumentField = Lambda.find(typeDef.fields, field -> field.name == staticOuterDocumentFieldName);
			if (staticOuterDocumentField != null) {
				var assignmentParts = typeDef.pack.copy();
				assignmentParts.push(typeDef.name);
				assignmentParts.push(staticOuterDocumentFieldName);
				return macro {
					$p{assignmentParts} = this;
					new $typePath();
				}
			}
		}
		return macro new $typePath();
	}

	/**
		Instantiates a component from markup.
	**/
	public macro static function withMarkup(input:ExprOf<String>, ?typePath:TypePath):Expr {
		posInfos = PositionTools.getInfos(input.pos);
		// skip the quotes
		posInfos.min++;
		posInfos.max--;
		var mxhxText:String = null;
		switch (input.expr) {
			case EMeta({name: META_MARKUP}, {expr: EConst(CString(s))}):
				mxhxText = s;
			case EConst(CString(s)):
				mxhxText = s;
			case _:
				throw new haxe.macro.Expr.Error("Expected markup or string literal", input.pos);
		}
		if (typePath == null) {
			var name = 'MXHXComponent_${componentCounter}';
			componentCounter++;
			typePath = {name: name, pack: PACKAGE_RESERVED};
		}
		if (mxhxResolver == null) {
			createResolver();
		}
		var outerDocumentTypePath:TypePath = null;
		var localClass = Context.getLocalClass().get();
		var localMethodName = Context.getLocalMethod();
		var localMethod = Lambda.find(localClass.statics.get(), field -> field.name == localMethodName);
		if (localMethod == null) {
			outerDocumentTypePath = {name: localClass.name, pack: localClass.pack};
		}
		var typeDef = createTypeDefinitionFromString(mxhxText, typePath, outerDocumentTypePath);
		if (typeDef == null) {
			return macro null;
		}
		Context.defineType(typeDef);
		if (outerDocumentTypePath != null) {
			var staticOuterDocumentFieldName = '${typeDef.name}_${FIELD_DEFAULT_OUTER_DOCUMENT}';
			var staticOuterDocumentField = Lambda.find(typeDef.fields, field -> field.name == staticOuterDocumentFieldName);
			if (staticOuterDocumentField != null) {
				var assignmentParts = typeDef.pack.copy();
				assignmentParts.push(typeDef.name);
				assignmentParts.push(staticOuterDocumentFieldName);
				return macro {
					$p{assignmentParts} = this;
					new $typePath();
				}
			}
		}
		return macro new $typePath();
	}

	#if macro
	/**
		Adds a custom mapping from a namespace URI to a list of components in
		the namespace.
	**/
	public static function registerMappings(uri:String, mappings:Map<String, String>):Void {
		manifests.set(uri, mappings);
	}

	/**
		Adds a custom mapping from a namespace URI to a list of components in
		the namespace using a manifest file.
	**/
	public static function registerManifest(uri:String, manifestPath:String):Void {
		if (!FileSystem.exists(manifestPath)) {
			Context.fatalError('Manifest file not found: ${manifestPath}', Context.currentPos());
		}
		var content = File.getContent(manifestPath);
		var xml:Xml = null;
		try {
			xml = Xml.parse(content);
		} catch (e:Dynamic) {
			reportErrorForContextPosition('Error parsing invalid XML in manifest file: ${manifestPath}', Context.currentPos());
			return;
		}
		var mappings:Map<String, String> = [];
		for (componentXml in xml.firstElement().elementsNamed("component")) {
			var xmlName = componentXml.get("id");
			var qname = componentXml.get("class");
			mappings.set(xmlName, qname);
		}
		manifests.set(uri, mappings);
	}

	public static function setDataBindingCallback(callback:(Expr, Expr, Expr) -> Expr):Void {
		dataBindingCallback = callback;
	}

	public static function setDispatchEventCallback(callback:(Expr, String) -> Expr):Void {
		dispatchEventCallback = callback;
	}

	public static function setAddEventListenerCallback(callback:(Expr, String, Expr) -> Expr):Void {
		addEventListenerCallback = callback;
	}

	private static function createResolver():Void {
		mxhxResolver = new MXHXMacroResolver();
		mxhxResolver.registerManifest(LANGUAGE_URI_BASIC_2024, LANGUAGE_MAPPINGS_2024);
		mxhxResolver.registerManifest(LANGUAGE_URI_FULL_2024, LANGUAGE_MAPPINGS_2024);
		for (uri => mappings in manifests) {
			mxhxResolver.registerManifest(uri, mappings);
		}
	}

	private static function createTypeDefinitionFromString(mxhxText:String, typePath:TypePath, outerDocumentTypePath:TypePath):TypeDefinition {
		var mxhxParser = new MXHXParser(mxhxText, posInfos.file);
		var mxhxData = mxhxParser.parse();
		if (mxhxData.problems.length > 0) {
			for (problem in mxhxData.problems) {
				reportError(problem.message, problem);
			}
			return null;
		}
		var typeDef:TypeDefinition = createTypeDefinitionFromTagData(mxhxData.rootTag, typePath, outerDocumentTypePath);
		if (typeDef == null) {
			return null;
		}
		return typeDef;
	}

	private static function createTypeDefinitionFromTagData(rootTag:IMXHXTagData, typePath:TypePath, outerDocumentTypePath:TypePath):TypeDefinition {
		var buildFields:Array<Field> = [];
		var implementsAttrData = rootTag.getAttributeData(ATTRIBUTE_IMPLEMENTS);
		if (implementsAttrData != null) {
			reportError('The \'${ATTRIBUTE_IMPLEMENTS}\' attribute is not supported', implementsAttrData);
		}
		var resolvedTag = handleRootTag(rootTag, INIT_FUNCTION_NAME, typePath, buildFields);

		var resolvedType:IMXHXTypeSymbol = null;
		var resolvedClass:IMXHXClassSymbol = null;
		if (resolvedTag != null) {
			if ((resolvedTag is IMXHXClassSymbol)) {
				resolvedClass = cast resolvedTag;
				resolvedType = cast resolvedTag;
			} else if ((resolvedTag is IMXHXTypeSymbol)) {
				resolvedType = cast resolvedTag;
			}
		}

		var componentName = typePath.name;
		var typeDef:TypeDefinition = null;
		if (resolvedClass != null) {
			var superClassTypePath = typeSymbolToTypePath(resolvedClass);
			typeDef = macro class $componentName extends $superClassTypePath {};
		} else if (resolvedType != null) {
			if (!isObjectTag(rootTag)) {
				reportError('Tag ${rootTag.name} cannot be used as a base class', rootTag);
			}
			typeDef = macro class $componentName {};
		} else {
			reportError('Tag ${rootTag.name} could not be resolved to a class', rootTag);
			typeDef = macro class $componentName {};
		}
		var initFunc = Lambda.find(buildFields, f -> f.name == INIT_FUNCTION_NAME);
		if (initFunc != null && resolvedClass != null && needsOverride(INIT_FUNCTION_NAME, resolvedClass)) {
			initFunc.access.push(AOverride);
			switch (initFunc.kind) {
				case FFun(f):
					var oldExpr = f.expr;
					f.expr = macro {
						super.$INIT_FUNCTION_NAME();
						$oldExpr;
					}
				default:
					reportError('Cannot find method ${INIT_FUNCTION_NAME} on class ${resolvedClass.name}', rootTag);
			}
		}
		for (buildField in buildFields) {
			if (resolvedClass == null || !fieldExists(buildField.name, resolvedClass)) {
				typeDef.fields.push(buildField);
			}
		}
		if (outerDocumentTypePath != null && !fieldExists(FIELD_OUTER_DOCUMENT, resolvedClass)) {
			addOuterDocumentField(typeDef, outerDocumentTypePath);
		}
		var typePos = sourceLocationToContextPosition(rootTag);
		typeDef.pack = typePath.pack;
		typeDef.pos = typePos;
		typeDef.meta = [
			{
				name: META_NO_COMPLETION,
				pos: typePos
			}
		];
		typeDef.doc = "Generated by MXHX";
		return typeDef;
	}

	private static function handleRootTag(tagData:IMXHXTagData, initFunctionName:String, outerDocumentTypePath:TypePath,
			buildFields:Array<Field>):IMXHXSymbol {
		var resolvedTag = mxhxResolver.resolveTag(tagData);
		if (resolvedTag == null) {
			errorTagUnexpected(tagData);
			return null;
		}
		var resolvedType:IMXHXTypeSymbol = null;
		if ((resolvedTag is IMXHXTypeSymbol)) {
			resolvedType = cast resolvedTag;
		}
		var prefixMap = tagData.parent.getPrefixMapForTag(tagData);
		if (tagData.parentTag == null) {
			// inline components inherit the language URI from the outer document
			var languageUris:Array<String> = [];
			for (uri in prefixMap.getAllUris()) {
				if (LANGUAGE_URIS.indexOf(uri) != -1) {
					languageUris.push(uri);
					if (uri == LANGUAGE_URI_FULL_2024) {
						var prefixes = prefixMap.getPrefixesForUri(uri);
						for (prefix in prefixes) {
							var attrData = tagData.getAttributeData('xmlns:$prefix');
							if (attrData != null) {
								if (!Context.defined("mxhx-disable-experimental-warning")
									&& !Context.defined("mxhx_disable_experimental_warning")) {
									Context.warning('Namespace \'$uri\' is experimental. Using namespace \'$LANGUAGE_URI_BASIC_2024\' instead is recommended.',
										sourceLocationToContextPosition(attrData));
								}
							}
						}
					}
				}
			}
			if (languageUris.length > 1) {
				for (uri in languageUris) {
					var prefixes = prefixMap.getPrefixesForUri(uri);
					for (prefix in prefixes) {
						var attrData = tagData.getAttributeData('xmlns:$prefix');
						if (attrData != null) {
							reportError("Only one language namespace may be used in an MXHX document.", attrData);
						}
					}
				}
			}
			if (languageUris.length > 0) {
				languageUri = languageUris[0];
			} else {
				languageUri = null;
			}
		}

		var originalFieldNames:Map<String, Bool> = [];
		for (field in buildFields) {
			originalFieldNames.set(field.name, true);
		}
		var generatedFields:Array<Field> = [];
		var bodyExprs:Array<Expr> = [];
		var attributeAndChildNames:Map<String, Bool> = [];
		handleAttributesOfInstanceTag(tagData, resolvedType, KEYWORD_THIS, bodyExprs, attributeAndChildNames);
		handleChildUnitsOfInstanceTag(tagData, resolvedType, KEYWORD_THIS, outerDocumentTypePath, generatedFields, bodyExprs, attributeAndChildNames);
		var constructorExprs:Array<Expr> = [];
		constructorExprs.push(macro this.$initFunctionName());
		var fieldPos = sourceLocationToContextPosition(tagData);
		var existingConstructor = Lambda.find(buildFields, f -> f.name == KEYWORD_NEW);
		if (existingConstructor != null) {
			switch (existingConstructor.kind) {
				case FFun(f):
					var blockExprs:Array<Expr> = null;
					var superIndex = -1;
					switch (f.expr.expr) {
						case EBlock(exprs):
							blockExprs = exprs;
							for (i in 0...blockExprs.length) {
								var exprInBlock = exprs[i];
								switch (exprInBlock.expr) {
									case ECall(e, params):
										switch (e.expr) {
											case EConst(CIdent("super")):
												superIndex = i;
											default:
										}
									default:
								}
							}
						default:
					}
					if (superIndex == -1) {
						constructorExprs = constructorExprs.concat(blockExprs);
					} else {
						var beginning = blockExprs.slice(0, superIndex + 1);
						var end = blockExprs.slice(superIndex + 1);
						constructorExprs = beginning.concat(constructorExprs).concat(end);
					}
					f.expr = macro $b{constructorExprs};
					existingConstructor.kind = FFun(f);
				default:
			}
		} else {
			if (resolvedTag != null && (resolvedTag is IMXHXClassSymbol) && !isObjectTag(tagData)) {
				constructorExprs.unshift(macro super());
			}
			buildFields.push({
				name: KEYWORD_NEW,
				pos: fieldPos,
				kind: FFun({
					args: [],
					ret: macro :Void,
					expr: macro $b{constructorExprs}
				}),
				access: [APublic]
			});
		}
		buildFields.push({
			name: initFunctionName,
			pos: fieldPos,
			kind: FFun({
				args: [],
				ret: macro :Void,
				expr: macro $b{bodyExprs},
			}),
			access: [APrivate],
			meta: [
				{
					name: META_NO_COMPLETION,
					pos: fieldPos
				}
			]
		});
		for (field in generatedFields) {
			if (originalFieldNames.exists(field.name)) {
				// no duplicates allowed! use the original
				continue;
			}
			buildFields.push(field);
		}
		var id:String = null;
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			reportError('id attribute is not allowed on the root tag of a component.', idAttr);
		}
		return resolvedTag;
	}

	private static function handleAttributesOfInstanceTag(tagData:IMXHXTagData, parentSymbol:IMXHXTypeSymbol, targetIdentifier:String, initExprs:Array<Expr>,
			attributeAndChildNames:Map<String, Bool>):Void {
		for (attribute in tagData.attributeData) {
			handleAttributeOfInstanceTag(attribute, parentSymbol, targetIdentifier, initExprs, attributeAndChildNames);
		}
	}

	private static function handleAttributeOfInstanceTag(attrData:IMXHXTagAttributeData, parentSymbol:IMXHXTypeSymbol, targetIdentifier:String,
			initExprs:Array<Expr>, attributeAndChildNames:Map<String, Bool>):Void {
		if (attrData.name == ATTRIBUTE_XMLNS || attrData.prefix == ATTRIBUTE_XMLNS) {
			// skip xmlns="" or xmlns:prefix=""
			return;
		}
		if (attributeAndChildNames.exists(attrData.name)) {
			errorDuplicateField(attrData.name, attrData.parentTag, getAttributeNameSourceLocation(attrData));
			return;
		}
		attributeAndChildNames.set(attrData.name, true);
		if (attrData.stateName != null) {
			errorStatesNotSupported(attrData);
			return;
		}
		var resolved = mxhxResolver.resolveAttribute(attrData);
		if (resolved == null) {
			var isAnyOrDynamic = parentSymbol != null
				&& parentSymbol.pack.length == 0
				&& (parentSymbol.name == TYPE_ANY || parentSymbol.name == TYPE_DYNAMIC);
			var isLanguageAttribute = ATTRIBUTES_THAT_CAN_BE_UNRESOLVED.indexOf(attrData.name) != -1;
			if (!isLanguageAttribute && attrData.name == ATTRIBUTE_IMPLEMENTS && attrData.parentTag == attrData.parentTag.parent.rootTag) {
				isLanguageAttribute = true;
			}
			if (isAnyOrDynamic && !isLanguageAttribute) {
				var valueExpr = createValueExprForDynamic(attrData.rawValue);
				var setExpr = macro Reflect.setField($i{targetIdentifier}, $v{attrData.shortName}, ${valueExpr});
				initExprs.push(setExpr);
				return;
			}
			if (isLanguageAttribute) {
				// certain special attributes don't need to resolve
				if (attrData.name == ATTRIBUTE_INCLUDE_IN || attrData.name == ATTRIBUTE_EXCLUDE_FROM) {
					var parentOfInstanceTag = attrData.parentTag.parentTag;
					if (parentOfInstanceTag != null && isLanguageTag(TAG_DECLARATIONS, parentOfInstanceTag)) {
						reportError('The includeIn and excludeFrom attributes are not allowed on immediate children of the <${parentOfInstanceTag.name}> tag',
							attrData);
					}
					errorStatesNotSupported(attrData);
				}
				return;
			}
			if (attrData.name == ATTRIBUTE_TYPE) {
				// type is a special attribute of Array that doesn't need to resolve
				var isArray = parentSymbol != null && parentSymbol.pack.length == 0 && parentSymbol.name == TYPE_ARRAY;
				if (isArray) {
					return;
				}
			}
			errorAttributeUnexpected(attrData);
			return;
		}
		if ((resolved is IMXHXEventSymbol)) {
			var eventSymbol:IMXHXEventSymbol = cast resolved;
			if (languageUri == LANGUAGE_URI_BASIC_2024) {
				errorEventsNotSupported(attrData);
				return;
			} else if (addEventListenerCallback == null) {
				errorEventsNotConfigured(attrData);
				return;
			} else {
				var dispatcherExpr = macro $i{targetIdentifier};
				var eventName = eventSymbol.name;
				var listenerExpr = Context.parse(attrData.rawValue, sourceLocationToContextPosition(attrData));
				var addEventExpr = addEventListenerCallback(dispatcherExpr, eventName, listenerExpr);
				initExprs.push(addEventExpr);
			}
		} else if ((resolved is IMXHXFieldSymbol)) {
			var fieldSymbol:IMXHXFieldSymbol = cast resolved;
			var fieldName = fieldSymbol.name;
			var destination = macro $i{targetIdentifier}.$fieldName;
			var valueExpr = handleTextContentAsExpr(attrData.rawValue, fieldSymbol.type, attrData.valueStart, getAttributeValueSourceLocation(attrData));
			if (dataBindingCallback != null && textContentContainsBinding(attrData.rawValue)) {
				var bindingExpr = dataBindingCallback(valueExpr, destination, macro this);
				initExprs.push(bindingExpr);
			} else {
				var setExpr = macro $destination = ${valueExpr};
				initExprs.push(setExpr);
			}
		} else {
			errorAttributeUnexpected(attrData);
		}
	}

	private static function handleDateTag(tagData:IMXHXTagData, generatedFields:Array<Field>):Expr {
		var intType = mxhxResolver.resolveQname(TYPE_INT);
		var hasCustom = false;
		var fullYear:Expr = null;
		var month:Expr = null;
		var date:Expr = null;
		var hours:Expr = null;
		var minutes:Expr = null;
		var seconds:Expr = null;
		for (attrData in tagData.attributeData) {
			switch (attrData.name) {
				case FIELD_FULL_YEAR:
					hasCustom = true;
					if (fullYear != null) {
						errorDuplicateField(FIELD_FULL_YEAR, tagData, getAttributeNameSourceLocation(attrData));
					}
					fullYear = createValueExprForTypeSymbol(intType, attrData.rawValue, false, attrData);
				case FIELD_MONTH:
					hasCustom = true;
					if (month != null) {
						errorDuplicateField(FIELD_MONTH, tagData, getAttributeNameSourceLocation(attrData));
					}
					month = createValueExprForTypeSymbol(intType, attrData.rawValue, false, attrData);
				case FIELD_DATE:
					hasCustom = true;
					if (date != null) {
						errorDuplicateField(FIELD_DATE, tagData, getAttributeNameSourceLocation(attrData));
					}
					date = createValueExprForTypeSymbol(intType, attrData.rawValue, false, attrData);
				case FIELD_HOURS:
					hasCustom = true;
					if (hours != null) {
						errorDuplicateField(FIELD_HOURS, tagData, getAttributeNameSourceLocation(attrData));
					}
					hours = createValueExprForTypeSymbol(intType, attrData.rawValue, false, attrData);
				case FIELD_MINUTES:
					hasCustom = true;
					if (minutes != null) {
						errorDuplicateField(FIELD_MINUTES, tagData, getAttributeNameSourceLocation(attrData));
					}
					minutes = createValueExprForTypeSymbol(intType, attrData.rawValue, false, attrData);
				case FIELD_SECONDS:
					hasCustom = true;
					if (seconds != null) {
						errorDuplicateField(FIELD_SECONDS, tagData, getAttributeNameSourceLocation(attrData));
					}
					seconds = createValueExprForTypeSymbol(intType, attrData.rawValue, false, attrData);
			}
		}

		var current = tagData.getFirstChildUnit();
		while (current != null) {
			if ((current is IMXHXTagData)) {
				var childTag:IMXHXTagData = cast current;
				if (childTag.uri != tagData.uri) {
					errorUnexpected(childTag);
					continue;
				}
				switch (childTag.shortName) {
					case FIELD_FULL_YEAR:
						hasCustom = true;
						if (fullYear != null) {
							errorDuplicateField(FIELD_FULL_YEAR, tagData, childTag);
						}
						fullYear = createValueExprForFieldTag(childTag, null, null, intType, null, generatedFields);
					case FIELD_MONTH:
						hasCustom = true;
						if (month != null) {
							errorDuplicateField(FIELD_MONTH, tagData, childTag);
						}
						month = createValueExprForFieldTag(childTag, null, null, intType, null, generatedFields);
					case FIELD_DATE:
						hasCustom = true;
						if (date != null) {
							errorDuplicateField(FIELD_DATE, tagData, childTag);
						}
						date = createValueExprForFieldTag(childTag, null, null, intType, null, generatedFields);
					case FIELD_HOURS:
						hasCustom = true;
						if (hours != null) {
							errorDuplicateField(FIELD_HOURS, tagData, childTag);
						}
						hours = createValueExprForFieldTag(childTag, null, null, intType, null, generatedFields);
					case FIELD_MINUTES:
						hasCustom = true;
						if (minutes != null) {
							errorDuplicateField(FIELD_MINUTES, tagData, childTag);
						}
						minutes = createValueExprForFieldTag(childTag, null, null, intType, null, generatedFields);
					case FIELD_SECONDS:
						hasCustom = true;
						if (seconds != null) {
							errorDuplicateField(FIELD_SECONDS, tagData, childTag);
						}
						seconds = createValueExprForFieldTag(childTag, null, null, intType, null, generatedFields);
					default:
						errorUnexpected(childTag);
				}
			} else if ((current is IMXHXTextData)) {
				var textData:IMXHXTextData = cast current;
				if (!canIgnoreTextData(textData)) {
					errorTextUnexpected(textData);
					break;
				}
			} else {
				errorUnexpected(current);
			}
			current = current.getNextSiblingUnit();
		}

		var valueExpr:Expr = null;
		if (!hasCustom) {
			valueExpr = macro Date.now();
		} else {
			var createExpr = macro var current = Date.now();
			var exprs = [createExpr];
			if (fullYear != null) {
				exprs.push(macro var fullYear = ${fullYear});
			} else {
				exprs.push(macro var fullYear = current.getFullYear());
			}
			if (month != null) {
				exprs.push(macro var month = ${month});
			} else {
				exprs.push(macro var month = current.getMonth());
			}
			if (date != null) {
				exprs.push(macro var date = ${date});
			} else {
				exprs.push(macro var date = current.getDate());
			}
			if (hours != null) {
				exprs.push(macro var hours = ${hours});
			} else {
				exprs.push(macro var hours = current.getHours());
			}
			if (minutes != null) {
				exprs.push(macro var minutes = ${minutes});
			} else {
				exprs.push(macro var minutes = current.getMinutes());
			}
			if (seconds != null) {
				exprs.push(macro var seconds = ${seconds});
			} else {
				exprs.push(macro var seconds = current.getSeconds());
			}
			exprs.push(macro new Date(fullYear, month, date, hours, minutes, seconds));
			valueExpr = macro $b{exprs};
		}

		var id:String = null;
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			id = idAttr.rawValue;
		}
		if (id != null) {
			var instanceTypePath:TypePath = {name: TYPE_DATE, pack: []};
			addFieldForID(id, TPath(instanceTypePath), idAttr, generatedFields);
			return macro this.$id = $valueExpr;
		}

		return valueExpr;
	}

	private static function handleXmlTag(tagData:IMXHXTagData, generatedFields:Array<Field>):Expr {
		var sourceAttr = tagData.getAttributeData(ATTRIBUTE_SOURCE);
		if (sourceAttr != null) {
			errorAttributeNotSupported(sourceAttr);
			return macro null;
		}
		var xmlDoc = Xml.createDocument();
		var current = tagData.getFirstChildUnit();
		var parentStack:Array<Xml> = [xmlDoc];
		var tagDataStack:Array<IMXHXTagData> = [];
		while (current != null) {
			if ((current is IMXHXTagData)) {
				var tagData:IMXHXTagData = cast current;
				if (tagData.isOpenTag()) {
					if (parentStack.length == 1 && xmlDoc.elements().hasNext()) {
						reportError("Only one root tag is allowed", tagData);
						break;
					}
					var elementChild = Xml.createElement(tagData.name);
					for (attrData in tagData.attributeData) {
						elementChild.set(attrData.name, attrData.rawValue);
					}
					parentStack[parentStack.length - 1].addChild(elementChild);
					if (!tagData.isEmptyTag()) {
						parentStack.push(elementChild);
						tagDataStack.push(tagData);
					}
				}
			} else if ((current is IMXHXTextData)) {
				var textData:IMXHXTextData = cast current;
				var textChild = switch (textData.textType) {
					case Text:
						if (textContentContainsBinding(textData.content)) {
							reportError('Binding is not supported here', textData);
						}
						Xml.createPCData(textData.content);
					case Whitespace: Xml.createPCData(textData.content);
					case CData: Xml.createCData(textData.content);
					case Comment | DocComment: Xml.createComment(textData.content);
				}
				parentStack[parentStack.length - 1].addChild(textChild);
			} else if ((current is IMXHXInstructionData)) {
				var instructionData:IMXHXInstructionData = cast current;
				var instructionChild = Xml.createProcessingInstruction(instructionData.instructionText);
				parentStack[parentStack.length - 1].addChild(instructionChild);
			}
			if (tagDataStack.length > 0 && tagDataStack[tagDataStack.length - 1] == current) {
				// just added a tag to the stack, so read its children
				var tagData:IMXHXTagData = cast current;
				current = tagData.getFirstChildUnit();
			} else {
				current = current.getNextSiblingUnit();
			}
			// if the top-most tag on the stack has no more child units,
			// return to its parent tag
			while (current == null && tagDataStack.length > 0) {
				var parentTag = tagDataStack.pop();
				parentStack.pop();
				current = parentTag.getNextSiblingUnit();
			}
		}

		var xmlString = xmlDoc.toString();
		var valueExpr = macro Xml.parse($v{xmlString});

		var id:String = null;
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			id = idAttr.rawValue;
		}
		if (id != null) {
			var instanceTypePath:TypePath = {name: TYPE_XML, pack: []};
			addFieldForID(id, TPath(instanceTypePath), idAttr, generatedFields);
			return macro this.$id = $valueExpr;
		}

		return valueExpr;
	}

	private static function handleModelTag(tagData:IMXHXTagData, generatedFields:Array<Field>):Expr {
		var sourceAttr = tagData.getAttributeData(ATTRIBUTE_SOURCE);
		if (sourceAttr != null) {
			errorAttributeNotSupported(sourceAttr);
			return macro null;
		}
		var current = tagData.getFirstChildUnit();
		var model:ModelObject;
		var rootTag:IMXHXTagData = null;
		var parentStack:Array<ModelObject> = [new ModelObject()];
		var tagDataStack:Array<IMXHXTagData> = [];
		while (current != null) {
			if ((current is IMXHXTagData)) {
				var tagData:IMXHXTagData = cast current;
				if (tagData.isOpenTag()) {
					if (rootTag == null) {
						rootTag = tagData;
					} else if (parentStack.length == 1) {
						reportError("Only one root tag is allowed", tagData);
						break;
					}
					var elementChild = new ModelObject();
					elementChild.location = tagData;
					// attributes are ignored on root tag, for some reason
					if (tagData != rootTag) {
						for (attrData in tagData.attributeData) {
							var objectsForField = elementChild.fields.get(attrData.shortName);
							if (objectsForField == null) {
								objectsForField = [];
								elementChild.fields.set(attrData.shortName, objectsForField);
							}
							var attrObject = new ModelObject(attrData.rawValue);
							attrObject.location = attrData;
							objectsForField.push(attrObject);
						}
					} else {
						for (attrData in tagData.attributeData) {
							Context.warning('Ignoring attribute \'${attrData.name}\' on root tag', sourceLocationToContextPosition(attrData));
						}
						model = elementChild;
					}
					var currentParent = parentStack[parentStack.length - 1];
					var parentObjectsForField = currentParent.fields.get(tagData.name);
					if (parentObjectsForField == null) {
						parentObjectsForField = [];
						currentParent.fields.set(tagData.name, parentObjectsForField);
					}
					parentObjectsForField.push(elementChild);
					currentParent.strongFields = true;

					if (!tagData.isEmptyTag()) {
						parentStack.push(elementChild);
						tagDataStack.push(tagData);
					}
				}
			} else if ((current is IMXHXTextData)) {
				var textData:IMXHXTextData = cast current;
				if (!canIgnoreTextData(textData)) {
					var currentParent = parentStack[parentStack.length - 1];
					currentParent.text.push(textData);
				}
			}
			if (tagDataStack.length > 0 && tagDataStack[tagDataStack.length - 1] == current) {
				// just added a tag to the stack, so read its children
				var tagData:IMXHXTagData = cast current;
				current = tagData.getFirstChildUnit();
			} else {
				current = current.getNextSiblingUnit();
			}
			// if the top-most tag on the stack has no more child units,
			// return to its parent tag
			while (current == null && tagDataStack.length > 0) {
				var parentTag = tagDataStack.pop();
				var popped = parentStack.pop();
				current = parentTag.getNextSiblingUnit();
			}
		}

		var valueExpr:Expr = null;
		if (model != null) {
			valueExpr = createModelObjectExpr(model, tagData);
		} else {
			valueExpr = {expr: EObjectDecl([]), pos: sourceLocationToContextPosition(tagData)};
		}

		var id:String = null;
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			id = idAttr.rawValue;
		}
		if (id != null) {
			var instanceTypePath:TypePath = {name: TYPE_DYNAMIC, pack: []};
			addFieldForID(id, TPath(instanceTypePath), idAttr, generatedFields);
			return macro this.$id = $valueExpr;
		}

		return valueExpr;
	}

	private static function createModelObjectExpr(model:ModelObject, sourceLocation:IMXHXSourceLocation):Expr {
		if (model.value != null) {
			return createValueExprForDynamic(model.value);
		}
		var textType:MXHXTextType = null;
		if (model.text.length > 0) {
			var hasFields = model.fields.iterator().hasNext() && model.strongFields;
			var hasMultipleTextTypes = model.text.length > 1;
			for (textData in model.text) {
				if (hasFields || hasMultipleTextTypes) {
					Context.warning('Ignoring text \'${textData.content}\' because other XML content exists', sourceLocationToContextPosition(textData));
					continue;
				}
				for (fieldName => models in model.fields) {
					for (current in models) {
						Context.warning('Ignoring attribute \'${fieldName}\' because other XML content exists',
							sourceLocationToContextPosition(current.location));
					}
				}
				if (textContentContainsBinding(textData.content)) {
					reportError('Binding is not supported here', textData);
				}
				return createValueExprForDynamic(textData.content);
			}
		}
		var subModelExprs:Array<Expr> = [];
		for (fieldName => subModels in model.fields) {
			if (subModels.length == 1) {
				var subModelSrcExpr = createModelObjectExpr(subModels[0], sourceLocation);
				var subModelExpr = macro Reflect.setField(model, $v{fieldName}, $subModelSrcExpr);
				subModelExprs.push(subModelExpr);
			} else {
				var arrayExprs:Array<Expr> = [];
				for (i in 0...subModels.length) {
					var subModel = subModels[i];
					var subModelSrcExpr = createModelObjectExpr(subModel, sourceLocation);
					var arrayExpr = macro array[$v{i}] = $subModelSrcExpr;
					arrayExprs.push(arrayExpr);
				}
				var subModelExpr = macro {
					var array:Array<Any> = [];
					$b{arrayExprs};
					Reflect.setField(model, $v{fieldName}, array);
				}
				subModelExprs.push(subModelExpr);
			}
		}
		if (subModelExprs.length == 0) {
			return {expr: EObjectDecl([]), pos: sourceLocationToContextPosition(sourceLocation)};
		}
		return macro {
			var model = {};
			$b{subModelExprs};
			model;
		}
	}

	private static function handleComponentTag(tagData:IMXHXTagData, assignedToType:IMXHXTypeSymbol, outerDocumentTypePath:TypePath,
			generatedFields:Array<Field>):Expr {
		var classNameAttr = tagData.getAttributeData(ATTRIBUTE_CLASS_NAME);
		if (classNameAttr != null) {
			errorAttributeNotSupported(classNameAttr);
		}
		var componentName = 'MXHXComponent_${componentCounter}';
		var functionName = 'createMXHXInlineComponent_${componentCounter}';
		componentCounter++;
		var typePath = {name: componentName, pack: PACKAGE_RESERVED};
		var typeDef = createTypeDefinitionFromTagData(tagData.getFirstChildTag(true), typePath, outerDocumentTypePath);
		if (typeDef == null) {
			return macro null;
		}

		var returnType:ComplexType = null;
		if (assignedToType != null) {
			returnType = TPath(typeSymbolToTypePath(assignedToType));
		} else {
			returnType = TPath({name: TYPE_CLASS, pack: [], params: [TPType(TPath(typePath))]});
		}

		Context.defineType(typeDef);

		// TODO: allow customization of returned expression based on the type
		// that is being assigned to

		var typeParts = typeDef.pack.copy();
		typeParts.push(typeDef.name);
		var assignmentParts = typeParts.copy();
		assignmentParts.push('${typeDef.name}_${FIELD_DEFAULT_OUTER_DOCUMENT}');
		var bodyExpr = macro {
			$p{assignmentParts} = this;
			var result:$returnType = $p{typeParts};
			return result;
		};

		var typePos = sourceLocationToContextPosition(tagData);
		generatedFields.push({
			name: functionName,
			pos: typePos,
			kind: FFun({
				args: [],
				ret: TPath({name: TYPE_DYNAMIC, pack: []}),
				expr: bodyExpr
			}),
			access: [APrivate],
			meta: [
				{
					name: META_NO_COMPLETION,
					pos: typePos
				}
			]
		});
		for (attribute in tagData.attributeData) {
			if (attribute.name != ATTRIBUTE_ID && attribute.name != ATTRIBUTE_CLASS_NAME) {
				errorAttributeUnexpected(attribute);
			}
		}
		var id:String = null;
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			id = idAttr.rawValue;
		}
		if (id != null) {
			addFieldForID(id, returnType, idAttr, generatedFields);
			return macro this.$id = $i{functionName}();
		}
		return macro $i{functionName}();
	}

	private static function handleInstanceTag(tagData:IMXHXTagData, assignedToType:IMXHXTypeSymbol, outerDocumentTypePath:TypePath,
			generatedFields:Array<Field>):Expr {
		if (isObjectTag(tagData)) {
			reportError('Tag \'<${tagData.name}>\' must only be used as a base class. Did you mean \'<${tagData.prefix}:${TAG_STRUCT}/>\'?', tagData);
		}
		var resolvedTag = mxhxResolver.resolveTag(tagData);
		if (resolvedTag == null) {
			errorTagUnexpected(tagData);
			return null;
		}
		if ((resolvedTag is IMXHXEnumFieldSymbol)) {
			var enumFieldSymbol:IMXHXEnumFieldSymbol = cast resolvedTag;
			return createInitExpr(tagData.parentTag, enumFieldSymbol.parent, outerDocumentTypePath, generatedFields);
		}
		var resolvedType:IMXHXTypeSymbol = null;
		var resolvedTypeParams:Array<IMXHXTypeSymbol> = null;
		var resolvedClass:IMXHXClassSymbol = null;
		var resolvedEnum:IMXHXEnumSymbol = null;
		var isArray = false;
		if (resolvedTag != null) {
			if ((resolvedTag is IMXHXClassSymbol)) {
				resolvedType = cast resolvedTag;
				resolvedClass = cast resolvedTag;
				resolvedEnum = null;
				resolvedTypeParams = resolvedType.params;
				isArray = resolvedType.pack.length == 0 && resolvedType.name == TYPE_ARRAY;
			} else if ((resolvedTag is IMXHXAbstractSymbol)) {
				resolvedType = cast resolvedTag;
				resolvedClass = null;
				resolvedEnum = null;
				resolvedTypeParams = resolvedType.params;
			} else if ((resolvedTag is IMXHXEnumSymbol)) {
				resolvedType = cast resolvedTag;
				resolvedClass = null;
				resolvedEnum = cast resolvedTag;
				resolvedTypeParams = resolvedType.params;
			} else {
				errorTagUnexpected(tagData);
			}
		}

		// some tags have special parsing rules, such as when there are
		// required constructor arguments for core language types
		if (resolvedType.pack.length == 0) {
			switch (resolvedType.name) {
				case TYPE_XML:
					return handleXmlTag(tagData, generatedFields);
				case TYPE_DATE:
					return handleDateTag(tagData, generatedFields);
				default:
			}
		}

		var localVarName = "object";
		var setFieldExprs:Array<Expr> = [];
		var attributeAndChildNames:Map<String, Bool> = [];
		handleAttributesOfInstanceTag(tagData, resolvedType, localVarName, setFieldExprs, attributeAndChildNames);
		handleChildUnitsOfInstanceTag(tagData, resolvedType, localVarName, outerDocumentTypePath, generatedFields, setFieldExprs, attributeAndChildNames);

		var instanceTypePath:TypePath = null;
		if (resolvedType == null) {
			// this probably shouldn't happen
			instanceTypePath = {name: TYPE_DYNAMIC, pack: []};
		} else {
			var qname = resolvedType.name;
			if (resolvedType.pack.length > 0) {
				qname = resolvedType.pack.join(".") + "." + qname;
			}
			instanceTypePath = typeSymbolToTypePath(resolvedType);
			if (isArray) {
				var paramType:ComplexType = null;
				if (resolvedTypeParams.length > 0) {
					var resolvedParam = resolvedTypeParams[0];
					if (resolvedParam != null) {
						paramType = TPath(typeSymbolToTypePath(resolvedParam));
					}
				}

				var attrData = tagData.getAttributeData(ATTRIBUTE_TYPE);
				if (paramType == null && attrData != null) {
					reportError('The type parameter \'${attrData.rawValue}\' for tag \'<${tagData.name}>\' cannot be resolved',
						getAttributeValueSourceLocation(attrData));
				}

				if (paramType == null && assignedToType != null) {
					// if this is being assigned to a field, we can
					// infer the correct type from the field's type
					if ((assignedToType is IMXHXClassSymbol)) {
						var classSymbol:IMXHXClassSymbol = cast assignedToType;
						if (classSymbol.pack.length == 0 && classSymbol.name == TYPE_ARRAY && classSymbol.params.length > 0) {
							var assignedParam = classSymbol.params[0];
							if (assignedParam != null) {
								paramType = TPath(typeSymbolToTypePath(assignedParam));
							}
						}
					}
				}
				if (paramType == null) {
					// next, try to infer the correct type from the array items
					var inferredType = inferTypeFromChildrenOfTag(tagData);
					if (inferredType != null) {
						paramType = TPath(typeSymbolToTypePath(inferredType));
					}
				}
				if (paramType == null) {
					// finally, default to null
					paramType = TPath({name: TYPE_DYNAMIC, pack: []});
				}

				instanceTypePath.params = [TPType(paramType)];
			}
		}

		var id:String = null;
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			id = idAttr.rawValue;
		}
		var setIDExpr:Expr = null;
		if (id != null) {
			addFieldForID(id, TPath(instanceTypePath), idAttr, generatedFields);
			setIDExpr = macro this.$id = $i{localVarName};
		} else {
			// field names can't start with a number, so starting a generated
			// id with a number won't conflict with real fields
			id = Std.string(Math.fceil(objectCounter));
			objectCounter++;
		}
		if (setIDExpr != null) {
			setFieldExprs.push(setIDExpr);
		}
		var bodyExpr:Expr = null;
		if (resolvedEnum != null || isLanguageTypeAssignableFromText(resolvedType)) {
			// no need for a function. return the simple expression.
			// handleChildUnitsOfInstanceTag() checks for too many children
			// so no need to worry about that here
			return setFieldExprs[0];
		} else if (resolvedClass == null) {
			bodyExpr = macro {
				var $localVarName:Dynamic = {};
				$b{setFieldExprs};
				return $i{localVarName};
			}
		} else {
			bodyExpr = macro {
				var $localVarName = new $instanceTypePath();
				$b{setFieldExprs};
				return $i{localVarName};
			}
		}
		var functionName = 'createMXHXObject_${id}';
		var fieldPos = sourceLocationToContextPosition(idAttr != null ? idAttr : tagData);

		generatedFields.push({
			name: functionName,
			pos: fieldPos,
			kind: FFun({
				args: [],
				ret: TPath(instanceTypePath),
				expr: bodyExpr
			}),
			access: [APrivate],
			meta: [
				{
					name: META_NO_COMPLETION,
					pos: fieldPos
				}
			]
		});
		return macro $i{functionName}();
	}

	private static function typeSymbolToTypePath(typeSymbol:IMXHXTypeSymbol):TypePath {
		var params:Array<TypeParam> = null;
		if (typeSymbol.params.length > 0) {
			params = typeSymbol.params.map(paramType -> TPType(TPath({pack: [], name: TYPE_DYNAMIC})));
		}
		if (typeSymbol.qname != typeSymbol.module) {
			var moduleParts = typeSymbol.module.split(".");
			return {
				name: moduleParts.pop(),
				pack: moduleParts,
				sub: typeSymbol.name,
				params: params
			};
		}
		return {name: typeSymbol.name, pack: typeSymbol.pack, params: params};
	}

	private static function tagContainsOnlyText(tagData:IMXHXTagData):Bool {
		var child = tagData.getFirstChildUnit();
		do {
			if ((child is IMXHXTextData)) {
				var textData:IMXHXTextData = cast child;
				switch (textData.textType) {
					case Text | CData | Whitespace:
					default:
						if (!canIgnoreTextData(textData)) {
							return false;
						}
				}
			} else {
				return false;
			}
			child = child.getNextSiblingUnit();
		} while (child != null);
		return true;
	}

	private static function handleInstanceTagEnumValue(tagData:IMXHXTagData, typeSymbol:IMXHXTypeSymbol, generatedFields:Array<Field>):Expr {
		var initExpr = createEnumFieldInitExpr(tagData, null, generatedFields);
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			var id = idAttr.rawValue;
			var typePath:TypePath = typeSymbolToTypePath(typeSymbol);
			if (typeSymbol.pack.length == 0 && typeSymbol.name == TYPE_CLASS) {
				typePath.params = [TPType(TPath({pack: [], name: TYPE_DYNAMIC}))];
			}
			addFieldForID(id, TPath(typePath), idAttr, generatedFields);
			initExpr = macro this.$id = $initExpr;
		}
		return initExpr;
	}

	private static function createEnumFieldInitExpr(tagData:IMXHXTagData, outerDocumentTypePath:TypePath, generatedFields:Array<Field>):Expr {
		var child = tagData.getFirstChildUnit();
		var childTag:IMXHXTagData = null;
		do {
			if ((child is IMXHXTagData)) {
				if (childTag != null) {
					errorTagUnexpected(cast child);
					break;
				}
				childTag = cast child;
			} else if ((child is IMXHXTextData)) {
				var textData:IMXHXTextData = cast child;
				if (!canIgnoreTextData(textData)) {
					errorTextUnexpected(textData);
					break;
				}
			}
			child = child.getNextSiblingUnit();
		} while (child != null);
		if (childTag == null) {
			errorTagUnexpected(tagData);
		}
		var resolvedTag = mxhxResolver.resolveTag(childTag);
		if (resolvedTag == null) {
			errorTagUnexpected(childTag);
		}
		if ((resolvedTag is IMXHXEnumFieldSymbol)) {
			var enumFieldSymbol:IMXHXEnumFieldSymbol = cast resolvedTag;
			var enumSymbol = enumFieldSymbol.parent;
			var fieldName = enumFieldSymbol.name;
			var args = enumFieldSymbol.args;
			if (args.length > 0) {
				var initArgs:Array<Expr> = [];
				var attrLookup:Map<String, IMXHXTagAttributeData> = [];
				var tagLookup:Map<String, IMXHXTagData> = [];
				for (attrData in childTag.attributeData) {
					attrLookup.set(attrData.shortName, attrData);
				}
				var grandChildTag = childTag.getFirstChildTag(true);
				while (grandChildTag != null) {
					tagLookup.set(grandChildTag.shortName, grandChildTag);
					grandChildTag = grandChildTag.getNextSiblingTag(true);
				}
				for (arg in args) {
					var argName = arg.name;
					if (attrLookup.exists(argName)) {
						var attrData = attrLookup.get(argName);
						attrLookup.remove(argName);
						var valueExpr = createValueExprForTypeSymbol(arg.type, attrData.rawValue, false, attrData);
						initArgs.push(valueExpr);
					} else if (tagLookup.exists(argName)) {
						var grandChildTag = tagLookup.get(argName);
						tagLookup.remove(argName);
						var valueExpr = createValueExprForFieldTag(grandChildTag, null, null, arg.type, outerDocumentTypePath, generatedFields);
						initArgs.push(valueExpr);
					} else if (arg.optional) {
						initArgs.push(macro null);
					} else {
						errorAttributeRequired(arg.name, childTag);
					}
				}
				for (tagName => grandChildTag in tagLookup) {
					errorTagUnexpected(grandChildTag);
				}
				for (attrName => attrData in attrLookup) {
					errorAttributeUnexpected(attrData);
				}
				if (enumSymbol.pack.length > 0) {
					var fieldExprParts = enumSymbol.pack.concat([enumSymbol.name, fieldName]);
					return macro $p{fieldExprParts}($a{initArgs});
				} else {
					var fieldExprParts = [enumSymbol.name, fieldName];
					return macro $p{fieldExprParts}($a{initArgs});
				}
			} else {
				if (enumSymbol.pack.length > 0) {
					var fieldExprParts = enumSymbol.pack.concat([enumSymbol.name, fieldName]);
					return macro $p{fieldExprParts};
				} else {
					var fieldExprParts = [enumSymbol.name, fieldName];
					return macro $p{fieldExprParts};
				}
			}
		} else {
			errorUnexpected(childTag);
		}
		return null;
	}

	private static function handleInstanceTagAssignableFromText(tagData:IMXHXTagData, typeSymbol:IMXHXTypeSymbol, generatedFields:Array<Field>):Expr {
		if (typeSymbol != null && typeSymbol.pack.length == 0 && typeSymbol.name == TYPE_STRING) {
			var sourceAttr = tagData.getAttributeData(ATTRIBUTE_SOURCE);
			if (sourceAttr != null) {
				errorAttributeNotSupported(sourceAttr);
				return macro null;
			}
		}
		var initExpr:Expr = null;
		var child = tagData.getFirstChildUnit();
		var bindingTextData:IMXHXTextData = null;
		if (child != null && (child is IMXHXTextData) && child.getNextSiblingUnit() == null) {
			var textData = cast(child, IMXHXTextData);
			if (textData.textType == Text && isLanguageTypeAssignableFromText(typeSymbol)) {
				initExpr = handleTextContentAsExpr(textData.content, typeSymbol, null, textData);
				bindingTextData = textData;
			}
		}
		if (initExpr == null) {
			var pendingText:String = null;
			var pendingTextIncludesCData = false;
			do {
				if (child == null) {
					if (initExpr != null) {
						// this shouldn't happen, but just to be safe
						errorTagUnexpected(tagData);
					} else {
						// no text found, so use default value instead
						initExpr = createDefaultValueExprForTypeSymbol(typeSymbol, tagData);
					}
					// no more children
					break;
				} else if ((child is IMXHXTextData)) {
					var textData:IMXHXTextData = cast child;
					switch (textData.textType) {
						case Text:
							if (pendingText != null && pendingTextIncludesCData) {
								// can't combine normal text and cdata text
								errorUnexpected(child);
								break;
							}
							var content = textData.content;
							if (textContentContainsBinding(content)) {
								reportError('Binding is not supported here', textData);
							}
							if (pendingText == null) {
								pendingText = content;
							} else {
								// append to existing normal text content
								pendingText += content;
							}
						case CData:
							if (pendingText != null && !pendingTextIncludesCData) {
								// can't combine normal text and cdata text
								errorUnexpected(child);
								break;
							}
							if (pendingText == null) {
								pendingText = textData.content;
							} else {
								// append to existing cdata content
								pendingText += textData.content;
							}
							pendingTextIncludesCData = true;
						default:
							// whitespace textType is never appended to the
							// pending text. it is ignored, like comments.
							if (!canIgnoreTextData(textData)) {
								errorTextUnexpected(textData);
								break;
							}
					}
				} else {
					// anything that isn't text is unexpected
					errorUnexpected(child);
				}
				child = child.getNextSiblingUnit();
				if (child == null && pendingText != null) {
					initExpr = createValueExprForTypeSymbol(typeSymbol, pendingText, pendingTextIncludesCData, tagData);
				}
			} while (child != null || initExpr == null);
		}
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			var id = idAttr.rawValue;
			var destination = macro this.$id;
			var typePath:TypePath = typeSymbolToTypePath(typeSymbol);
			if (typeSymbol.pack.length == 0 && typeSymbol.name == TYPE_CLASS) {
				typePath.params = [TPType(TPath({pack: [], name: TYPE_DYNAMIC}))];
			}
			addFieldForID(id, TPath(typePath), idAttr, generatedFields);
			if (bindingTextData != null && dataBindingCallback != null && textContentContainsBinding(bindingTextData.content)) {
				initExpr = dataBindingCallback(initExpr, destination, macro this);
			} else {
				initExpr = macro $destination = $initExpr;
			}
		}
		for (attribute in tagData.attributeData) {
			if (attribute.name != ATTRIBUTE_ID) {
				errorAttributeUnexpected(attribute);
			}
		}
		return initExpr;
	}

	private static function handleTextContentAsExpr(text:String, fieldType:IMXHXTypeSymbol, textStartOffset:Int, sourceLocation:IMXHXSourceLocation):Expr {
		var expr:Expr = null;
		var startIndex = 0;
		var pendingText:String = "";
		do {
			var bindingStartIndex = text.indexOf("{", startIndex);
			if (bindingStartIndex == -1) {
				if (expr == null && pendingText.length == 0) {
					return createValueExprForTypeSymbol(fieldType, text, false, sourceLocation);
				}
				pendingText += text.substring(startIndex);
				if (pendingText.length > 0) {
					if (expr == null) {
						expr = macro $v{pendingText};
					} else {
						expr = macro $expr + $v{pendingText};
					}
					pendingText = "";
				}
				break;
			}
			if (bindingStartIndex > 0 && text.charAt(bindingStartIndex - 1) == "\\") {
				// the { character is escaped, so it's not binding
				pendingText += text.substring(startIndex, bindingStartIndex - 1) + "{";
				startIndex = bindingStartIndex + 1;
			} else {
				pendingText += text.substring(startIndex, bindingStartIndex);
				startIndex = bindingStartIndex + 1;
				// valid start of binding if previous character is not a backslash
				var bindingEndIndex = -1;
				var stack = 1;
				for (i in (bindingStartIndex + 1)...text.length) {
					var char = text.charAt(i);
					if (char == "{") {
						stack++;
					} else if (char == "}") {
						stack--;
						if (stack == 0) {
							bindingEndIndex = i;
							break;
						}
					}
				}
				if (bindingEndIndex != -1) {
					if (languageUri == LANGUAGE_URI_BASIC_2024) {
						errorBindingNotSupported(new CustomMXHXSourceLocation(sourceLocation.start + bindingStartIndex,
							sourceLocation.start + bindingEndIndex + 1, sourceLocation.source));
						return null;
					}
					if (pendingText.length > 0) {
						if (expr == null) {
							expr = macro $v{pendingText};
						} else {
							expr = macro $expr + $v{pendingText};
						}
						pendingText = "";
					}
					var bindingContent = text.substring(bindingStartIndex + 1, bindingEndIndex);
					var bindingExpr = Context.parse(bindingContent, sourceLocationToContextPosition(sourceLocation));
					if (expr == null) {
						expr = macro $bindingExpr;
					} else {
						expr = macro $expr + $bindingExpr;
					}
					startIndex = bindingEndIndex + 1;
				}
			}
		} while (true);
		return expr;
	}

	private static function textContentContainsBinding(text:String):Bool {
		var startIndex = 0;
		do {
			var bindingStartIndex = text.indexOf("{", startIndex);
			if (bindingStartIndex == -1) {
				break;
			}
			startIndex = bindingStartIndex + 1;
			if (bindingStartIndex > 0 && text.charAt(bindingStartIndex - 1) == "\\") {
				// remove the escaped { character
				text = text.substr(0, bindingStartIndex - 1) + text.substr(bindingStartIndex);
				startIndex--;
			} else {
				// valid start of binding if previous character is not a backslash
				var bindingEndIndex = -1;
				var stack = 1;
				for (i in (bindingStartIndex + 1)...text.length) {
					var char = text.charAt(i);
					if (char == "{") {
						stack++;
					} else if (char == "}") {
						stack--;
						if (stack == 0) {
							bindingEndIndex = i;
							break;
						}
					}
				}
				if (bindingEndIndex != -1) {
					return true;
				}
			}
		} while (true);
		return false;
	}

	private static function handleChildUnitsOfDeclarationsTag(tagData:IMXHXTagData, outerDocumentTypePath:TypePath, generatedFields:Array<Field>,
			initExprs:Array<Expr>):Void {
		var current = tagData.getFirstChildUnit();
		while (current != null) {
			handleChildUnitOfArrayOrDeclarationsTag(current, outerDocumentTypePath, generatedFields, initExprs);
			current = current.getNextSiblingUnit();
		}
	}

	private static function createInitExpr(tagData:IMXHXTagData, typeSymbol:IMXHXTypeSymbol, outerDocumentTypePath:TypePath,
			generatedFields:Array<Field>):Expr {
		var initExpr:Expr = null;
		if ((typeSymbol is IMXHXEnumSymbol)) {
			if (!tagContainsOnlyText(tagData)) {
				initExpr = handleInstanceTagEnumValue(tagData, typeSymbol, generatedFields);
			} else {
				initExpr = handleInstanceTagAssignableFromText(tagData, typeSymbol, generatedFields);
			}
		} else if (isLanguageTypeAssignableFromText(typeSymbol)) {
			initExpr = handleInstanceTagAssignableFromText(tagData, typeSymbol, generatedFields);
		} else {
			initExpr = handleInstanceTag(tagData, null, outerDocumentTypePath, generatedFields);
		}
		return initExpr;
	}

	private static function handleChildUnitOfArrayOrDeclarationsTag(unitData:IMXHXUnitData, outerDocumentTypePath:TypePath, generatedFields:Array<Field>,
			initExprs:Array<Expr>):Void {
		if ((unitData is IMXHXInstructionData)) {
			// safe to ignore
			return;
		}
		if ((unitData is IMXHXTextData)) {
			var textData:IMXHXTextData = cast unitData;
			if (!canIgnoreTextData(textData)) {
				errorTextUnexpected(textData);
			}
			return;
		}
		if (!(unitData is IMXHXTagData)) {
			errorUnexpected(unitData);
			return;
		}

		var tagData:IMXHXTagData = cast unitData;
		var parentIsRoot = tagData.parentTag == tagData.parent.rootTag;
		if (!checkUnsupportedLanguageTag(tagData)) {
			return;
		}
		if (!checkRootLanguageTag(tagData)) {
			return;
		}
		if (isComponentTag(tagData)) {
			var initExpr = handleComponentTag(tagData, null, outerDocumentTypePath, generatedFields);
			initExprs.push(initExpr);
			return;
		}
		if (isLanguageTag(TAG_MODEL, tagData)) {
			var initExpr = handleModelTag(tagData, generatedFields);
			initExprs.push(initExpr);
			return;
		}
		var resolvedTag = mxhxResolver.resolveTag(tagData);
		if (resolvedTag == null) {
			errorTagUnexpected(tagData);
			return;
		} else {
			if ((resolvedTag is IMXHXClassSymbol)) {
				var classSymbol:IMXHXClassSymbol = cast resolvedTag;
				var initExpr = createInitExpr(tagData, classSymbol, outerDocumentTypePath, generatedFields);
				initExprs.push(initExpr);
				return;
			} else if ((resolvedTag is IMXHXAbstractSymbol)) {
				var abstractSymbol:IMXHXAbstractSymbol = cast resolvedTag;
				var initExpr = createInitExpr(tagData, abstractSymbol, outerDocumentTypePath, generatedFields);
				initExprs.push(initExpr);
				return;
			} else if ((resolvedTag is IMXHXEnumSymbol)) {
				var enumSymbol:IMXHXEnumSymbol = cast resolvedTag;
				var initExpr = createInitExpr(tagData, enumSymbol, outerDocumentTypePath, generatedFields);
				initExprs.push(initExpr);
				return;
			} else {
				errorTagUnexpected(tagData);
				return;
			}
		}
	}

	private static function handleChildUnitsOfInstanceTag(tagData:IMXHXTagData, parentSymbol:IMXHXTypeSymbol, targetIdentifier:String,
			outerDocumentTypePath:TypePath, generatedFields:Array<Field>, initExprs:Array<Expr>, attributeAndChildNames:Map<String, Bool>):Void {
		var parentClass:IMXHXClassSymbol = null;
		var parentEnum:IMXHXEnumSymbol = null;
		var isArray = false;
		if (parentSymbol != null) {
			if ((parentSymbol is IMXHXClassSymbol)) {
				parentClass = cast parentSymbol;
				isArray = parentClass.pack.length == 0 && parentClass.name == TYPE_ARRAY;
			} else if ((parentSymbol is IMXHXEnumSymbol)) {
				parentEnum = cast parentSymbol;
			}
		}

		if (parentEnum != null || isLanguageTypeAssignableFromText(parentSymbol)) {
			initExprs.push(createInitExpr(tagData, parentSymbol, outerDocumentTypePath, generatedFields));
			return;
		}

		var defaultProperty:String = null;
		var currentClass = parentClass;
		while (currentClass != null) {
			defaultProperty = currentClass.defaultProperty;
			if (defaultProperty != null) {
				break;
			}
			var superClass = currentClass.superClass;
			if (superClass == null) {
				break;
			}
			currentClass = superClass;
		}
		if (defaultProperty != null) {
			handleChildUnitsOfInstanceTagWithDefaultProperty(tagData, parentSymbol, defaultProperty, targetIdentifier, outerDocumentTypePath, generatedFields,
				initExprs, attributeAndChildNames);
			return;
		}

		var arrayChildren:Array<IMXHXUnitData> = isArray ? [] : null;
		var current = tagData.getFirstChildUnit();
		while (current != null) {
			handleChildUnitOfInstanceTag(current, parentSymbol, targetIdentifier, outerDocumentTypePath, generatedFields, initExprs, attributeAndChildNames,
				arrayChildren);
			current = current.getNextSiblingUnit();
		}
		if (!isArray) {
			return;
		}

		var arrayExprs:Array<Expr> = [];
		for (child in arrayChildren) {
			handleChildUnitOfArrayOrDeclarationsTag(child, outerDocumentTypePath, generatedFields, arrayExprs);
		}
		for (i in 0...arrayExprs.length) {
			var arrayExpr = arrayExprs[i];
			var initExpr = macro $i{targetIdentifier}[$v{i}] = $arrayExpr;
			initExprs.push(initExpr);
		}
	}

	private static function handleChildUnitsOfInstanceTagWithDefaultProperty(tagData:IMXHXTagData, parentSymbol:IMXHXTypeSymbol, defaultProperty:String,
			targetIdentifier:String, outerDocumentTypePath:TypePath, generatedFields:Array<Field>, initExprs:Array<Expr>,
			attributeAndChildNames:Map<String, Bool>):Void {
		var defaultChildren:Array<IMXHXUnitData> = [];
		var current = tagData.getFirstChildUnit();
		while (current != null) {
			handleChildUnitOfInstanceTag(current, parentSymbol, targetIdentifier, outerDocumentTypePath, generatedFields, initExprs, attributeAndChildNames,
				defaultChildren);
			current = current.getNextSiblingUnit();
		}

		if (defaultChildren.length == 0) {
			return;
		}
		var resolvedField = mxhxResolver.resolveTagField(tagData, defaultProperty);
		if (resolvedField == null) {
			reportError('Default property \'${defaultProperty}\' not found for tag \'<${tagData.name}>\'', tagData);
			return;
		}

		var fieldName = resolvedField.name;
		attributeAndChildNames.set(fieldName, true);

		var valueExpr = createValueExprForFieldTag(tagData, defaultChildren, resolvedField, null, outerDocumentTypePath, generatedFields);
		var initExpr = macro $i{targetIdentifier}.$fieldName = ${valueExpr};
		initExprs.push(initExpr);
	}

	private static function checkUnsupportedLanguageTag(tagData:IMXHXTagData):Bool {
		for (unsupportedTagShortName in UNSUPPORTED_LANGUAGE_TAGS) {
			if (isLanguageTag(unsupportedTagShortName, tagData)) {
				errorTagNotSupported(tagData);
				return false;
			}
		}
		return true;
	}

	private static function checkRootLanguageTag(tagData:IMXHXTagData):Bool {
		for (rootTagShortName in ROOT_LANGUAGE_TAGS) {
			if (isLanguageTag(rootTagShortName, tagData)) {
				reportError('Tag \'<${tagData.name}>\' must be a child of the root element', tagData);
				return false;
			}
		}
		return true;
	}

	private static function handleChildUnitOfInstanceTag(unitData:IMXHXUnitData, parentSymbol:IMXHXTypeSymbol, targetIdentifier:String,
			outerDocumentTypePath:TypePath, generatedFields:Array<Field>, initExprs:Array<Expr>, attributeAndChildNames:Map<String, Bool>,
			defaultChildren:Array<IMXHXUnitData>):Void {
		if ((unitData is IMXHXTagData)) {
			var tagData:IMXHXTagData = cast unitData;
			var parentIsRoot = tagData.parentTag == tagData.parent.rootTag;
			if (!checkUnsupportedLanguageTag(tagData)) {
				return;
			}
			if (!parentIsRoot) {
				if (!checkRootLanguageTag(tagData)) {
					return;
				}
			} else {
				if (isLanguageTag(TAG_DECLARATIONS, tagData)) {
					checkForInvalidAttributes(tagData, false);
					handleChildUnitsOfDeclarationsTag(tagData, outerDocumentTypePath, generatedFields, initExprs);
					return;
				}
				if (isLanguageTag(TAG_BINDING, tagData)) {
					handleBindingTag(tagData, initExprs);
					return;
				}
			}
			var resolvedTag = mxhxResolver.resolveTag(tagData);
			if (resolvedTag == null) {
				var isAnyOrDynamic = parentSymbol != null
					&& parentSymbol.pack.length == 0
					&& (parentSymbol.name == TYPE_ANY || parentSymbol.name == TYPE_DYNAMIC);
				if (isAnyOrDynamic && tagData.prefix == tagData.parentTag.prefix) {
					checkForInvalidAttributes(tagData, false);
					if (tagData.stateName != null) {
						errorStatesNotSupported(tagData);
						return;
					}
					var fieldName = tagData.shortName;
					var valueExpr = createValueExprForFieldTag(tagData, null, null, null, outerDocumentTypePath, generatedFields);
					var initExpr = macro $i{targetIdentifier}.$fieldName = ${valueExpr};
					initExprs.push(initExpr);
					return;
				}
				errorTagUnexpected(tagData);
				return;
			} else {
				if ((resolvedTag is IMXHXEventSymbol)) {
					var eventSymbol:IMXHXEventSymbol = cast resolvedTag;
					if (languageUri == LANGUAGE_URI_BASIC_2024) {
						errorEventsNotSupported(tagData);
						return;
					} else {
						var eventName = eventSymbol.name;
						var eventExpr:Expr = null;
						var unitData = tagData.getFirstChildUnit();
						while (unitData != null) {
							if (eventExpr != null) {
								errorUnexpected(unitData);
								return;
							}
							if ((unitData is IMXHXTextData)) {
								var textData:IMXHXTextData = cast unitData;
								if (canIgnoreTextData(textData)) {
									continue;
								}
								eventExpr = Context.parse(textData.content, sourceLocationToContextPosition(textData));
							} else {
								errorUnexpected(unitData);
								return;
							}
							unitData = unitData.getNextSiblingUnit();
						}
						if (eventExpr == null) {
							eventExpr = macro return;
						}
						var addEventExpr = macro $i{targetIdentifier}.addEventListener($v{eventName}, (event) -> ${eventExpr});
						initExprs.push(addEventExpr);
					}
				} else if ((resolvedTag is IMXHXFieldSymbol)) {
					var fieldSymbol:IMXHXFieldSymbol = cast resolvedTag;

					if (attributeAndChildNames.exists(tagData.name)) {
						errorDuplicateField(tagData.name, tagData.parentTag, tagData);
						return;
					}
					attributeAndChildNames.set(tagData.name, true);
					if (tagData.stateName != null) {
						errorStatesNotSupported(tagData);
						return;
					}
					checkForInvalidAttributes(tagData, false);
					var fieldName = fieldSymbol.name;
					var valueExpr = createValueExprForFieldTag(tagData, null, fieldSymbol, null, outerDocumentTypePath, generatedFields);
					var initExpr = macro $i{targetIdentifier}.$fieldName = ${valueExpr};
					initExprs.push(initExpr);
					return;
				} else if ((resolvedTag is IMXHXClassSymbol)) {
					var classSymbol:IMXHXClassSymbol = cast resolvedTag;

					if (defaultChildren == null) {
						errorTagUnexpected(tagData);
						return;
					}
					defaultChildren.push(unitData);
					return;
				} else if ((resolvedTag is IMXHXAbstractSymbol)) {
					var abstractSymbol:IMXHXAbstractSymbol = cast resolvedTag;

					if (defaultChildren == null) {
						errorTagUnexpected(tagData);
						return;
					}
					defaultChildren.push(unitData);
					return;
				} else if ((resolvedTag is IMXHXEnumSymbol)) {
					var enumSymbol:IMXHXEnumSymbol = cast resolvedTag;

					if (defaultChildren == null) {
						errorTagUnexpected(tagData);
						return;
					}
					defaultChildren.push(unitData);
					return;
				} else {
					errorTagUnexpected(tagData);
					return;
				}
			}
		} else if ((unitData is IMXHXTextData)) {
			var textData:IMXHXTextData = cast unitData;
			if (canIgnoreTextData(textData)) {
				return;
			}
			if (defaultChildren == null) {
				errorTextUnexpected(textData);
				return;
			}
			defaultChildren.push(unitData);
			return;
		} else if ((unitData is IMXHXInstructionData)) {
			// safe to ignore
			return;
		} else {
			errorUnexpected(unitData);
			return;
		}
	}

	private static function handleBindingTag(tagData:IMXHXTagData, initExprs:Array<Expr>):Void {
		if (languageUri == LANGUAGE_URI_BASIC_2024) {
			errorBindingNotSupported(tagData);
			return;
		}
		var destAttrData = tagData.getAttributeData(ATTRIBUTE_DESTINATION);
		if (destAttrData == null) {
			errorAttributeRequired(ATTRIBUTE_DESTINATION, tagData);
		}
		var sourceAttrData = tagData.getAttributeData(ATTRIBUTE_SOURCE);
		if (sourceAttrData == null) {
			errorAttributeRequired(ATTRIBUTE_SOURCE, tagData);
		}
		var twoWayAttrData = tagData.getAttributeData(ATTRIBUTE_TWO_WAY);
		if (twoWayAttrData != null) {
			errorAttributeNotSupported(twoWayAttrData);
		}
		for (attribute in tagData.attributeData) {
			if (attribute.name != ATTRIBUTE_DESTINATION && attribute.name != ATTRIBUTE_SOURCE && attribute.name != ATTRIBUTE_TWO_WAY) {
				errorAttributeUnexpected(attribute);
			}
		}
		var childUnit = tagData.getFirstChildUnit();
		while (childUnit != null) {
			if ((childUnit is IMXHXTextData)) {
				var textData:IMXHXTextData = cast childUnit;
				if (canIgnoreTextData(textData)) {
					childUnit = childUnit.getNextSiblingUnit();
					continue;
				}
			}
			errorUnexpected(childUnit);
			break;
		}
		var sourceExpr = Context.parse(sourceAttrData.rawValue, sourceLocationToContextPosition(sourceAttrData));
		var destExpr = Context.parse(destAttrData.rawValue, sourceLocationToContextPosition(destAttrData));
		if (dataBindingCallback != null) {
			var bindingExpr = dataBindingCallback(sourceExpr, destExpr, macro this);
			initExprs.push(bindingExpr);
		} else {
			var setExpr = macro $destExpr = $sourceExpr;
			initExprs.push(setExpr);
		}
	}

	private static function createValueExprForFieldTag(tagData:IMXHXTagData, childUnits:Array<IMXHXUnitData>, field:IMXHXFieldSymbol,
			fieldType:IMXHXTypeSymbol, outerDocumentTypePath:TypePath, generatedFields:Array<Field>):Expr {
		var isArray = false;
		var isString = false;
		var fieldName:String = tagData.shortName;
		// field may be null if it's on a struct
		if (field != null) {
			fieldName = field.name;
			fieldType = field.type;
		}

		if (fieldType != null) {
			isArray = fieldType.pack.length == 0 && fieldType.name == TYPE_ARRAY;
			isString = fieldType.pack.length == 0 && fieldType.name == TYPE_STRING;
		}

		var firstChildIsArrayTag = false;
		var valueExprs:Array<Expr> = [];
		var pendingText:String = null;
		var pendingTextIncludesCData = false;
		var firstChild = (childUnits != null) ? childUnits.shift() : tagData.getFirstChildUnit();
		var current = firstChild;
		while (current != null) {
			var next = (childUnits != null) ? childUnits.shift() : current.getNextSiblingUnit();
			if ((current is IMXHXTextData)) {
				var textData = cast(current, IMXHXTextData);
				if (textData == firstChild && next == null && textData.textType == Text && isLanguageTypeAssignableFromText(fieldType)) {
					return handleTextContentAsExpr(textData.content, fieldType, 0, textData);
				}
				if (!canIgnoreTextData(textData)) {
					if (valueExprs.length > 0) {
						// can't combine text and tags (at this time)
						errorTextUnexpected(textData);
					} else if (pendingText == null) {
						var textData = cast(current, IMXHXTextData);
						pendingText = textData.content;
						pendingTextIncludesCData = textData.textType == CData;
					} else {
						var textData = cast(current, IMXHXTextData);
						if ((pendingTextIncludesCData && textData.textType != CData)
							|| (!pendingTextIncludesCData && textData.textType == CData)) {
							// can't combine normal text and cdata text
							errorTextUnexpected(textData);
						} else {
							pendingText += textData.content;
						}
					}
				}
				current = next;
				continue;
			} else if (pendingText != null) {
				errorUnexpected(current);
				current = next;
				continue;
			}
			if (!isArray && valueExprs.length > 0) {
				// when the type is not array, multiple children are not allowed
				errorUnexpected(current);
				current = next;
				continue;
			}
			var valueExpr = createValueExprForUnitData(current, fieldType, outerDocumentTypePath, generatedFields);
			if (valueExpr != null) {
				if (valueExprs.length == 0 && (current is IMXHXTagData)) {
					var tagData:IMXHXTagData = cast current;
					if (tagData.shortName == TYPE_ARRAY && tagData.uri == languageUri) {
						firstChildIsArrayTag = true;
					}
				}
				valueExprs.push(valueExpr);
			}
			current = next;
		}
		if (pendingText != null) {
			var valueExpr:Expr = null;
			if (fieldType != null) {
				valueExpr = createValueExprForTypeSymbol(fieldType, pendingText, pendingTextIncludesCData, tagData);
			} else {
				valueExpr = createValueExprForDynamic(pendingText);
			}
			valueExprs.push(valueExpr);
		}
		if (valueExprs.length == 0 && !isArray) {
			if (isString) {
				return macro "";
			}
			reportError('Value for field \'${fieldName}\' must not be empty', tagData);
			return null;
		}

		if (isArray) {
			if (valueExprs.length == 1 && firstChildIsArrayTag) {
				return valueExprs[0];
			}

			var result:Array<Expr> = [];
			var localVarName = "array_" + fieldName;
			if (fieldType != null) {
				var paramType:ComplexType = null;
				if (fieldType.params.length == 0) {
					// if missing, the type was explicit, but could not be resolved
					reportError('Resolved field \'${fieldName}\' to type \'${fieldType.qname}\', but type parameter is missing', tagData);
				} else {
					var typeParam = fieldType.params[0];
					if (typeParam != null) {
						paramType = TPath(typeSymbolToTypePath(typeParam));
					}
				}

				var attrData = tagData.getAttributeData(ATTRIBUTE_TYPE);
				if (paramType == null && attrData != null) {
					reportError('The type parameter \'${attrData.rawValue}\' for tag \'<${tagData.name}>\' cannot be resolved',
						getAttributeValueSourceLocation(attrData));
				}

				if (paramType == null) {
					// next, try to infer the correct type from the array items
					var inferredType = inferTypeFromChildrenOfTag(tagData);
					if (inferredType != null) {
						paramType = TPath(typeSymbolToTypePath(inferredType));
					}
				}
				if (paramType == null) {
					// finally, default to null
					paramType = TPath({name: TYPE_DYNAMIC, pack: []});
				}

				result.push(macro var $localVarName:Array<$paramType> = []);
			} else {
				result.push(macro var $localVarName:Array<Dynamic> = []);
			}
			for (i in 0...valueExprs.length) {
				var valueExpr = valueExprs[i];
				var initExpr = macro $i{localVarName}[$v{i}] = ${valueExpr};
				result.push(initExpr);
			}
			result.push(macro $i{localVarName});
			return macro $b{result};
		}
		// not an array
		if (valueExprs.length > 1) {
			// this shouldn't happen, but just to be safe
			reportError('Too many expressions for field \'${fieldName}\'', tagData);
		}
		return valueExprs[0];
	}

	private static function createValueExprForUnitData(unitData:IMXHXUnitData, assignedToType:IMXHXTypeSymbol, outerDocumentTypePath:TypePath,
			generatedFields:Array<Field>):Expr {
		if ((unitData is IMXHXTagData)) {
			var tagData:IMXHXTagData = cast unitData;
			if (isComponentTag(tagData)) {
				return handleComponentTag(tagData, assignedToType, outerDocumentTypePath, generatedFields);
			}
			if (isLanguageTag(TAG_MODEL, tagData)) {
				return handleModelTag(tagData, generatedFields);
			}
			return handleInstanceTag(tagData, assignedToType, outerDocumentTypePath, generatedFields);
		} else if ((unitData is IMXHXTextData)) {
			var textData:IMXHXTextData = cast unitData;
			if (canIgnoreTextData(textData)) {
				return null;
			}
			if (assignedToType != null) {
				var fromCdata = switch (textData.textType) {
					case CData: true;
					default: false;
				}
				return createValueExprForTypeSymbol(assignedToType, textData.content, fromCdata, unitData);
			}
			return createValueExprForDynamic(textData.content);
		} else if ((unitData is IMXHXInstructionData)) {
			// safe to ignore
			return null;
		} else {
			errorUnexpected(unitData);
			return null;
		}
	}

	private static function isObjectTag(tagData:IMXHXTagData):Bool {
		return tagData != null && tagData.shortName == TAG_OBJECT && LANGUAGE_URIS.indexOf(tagData.uri) != -1;
	}

	private static function isComponentTag(tagData:IMXHXTagData):Bool {
		return tagData != null && tagData.shortName == TAG_COMPONENT && LANGUAGE_URIS.indexOf(tagData.uri) != -1;
	}

	private static function isLanguageTag(expectedShortName:String, tagData:IMXHXTagData):Bool {
		return tagData != null && tagData.shortName == expectedShortName && LANGUAGE_URIS.indexOf(tagData.uri) != -1;
	}

	private static function isLanguageTypeAssignableFromText(t:IMXHXTypeSymbol):Bool {
		if (t == null) {
			return false;
		}
		if (t.pack.length == 1 && t.pack[0] == "haxe" && t.name == TYPE_FUNCTION) {
			return true;
		}
		return t.pack.length == 0 && LANGUAGE_TYPES_ASSIGNABLE_BY_TEXT.indexOf(t.name) != -1;
	}

	private static function canIgnoreTextData(textData:IMXHXTextData):Bool {
		if (textData == null) {
			return true;
		}
		return switch (textData.textType) {
			case Whitespace | Comment | DocComment: true;
			default: false;
		}
	}

	private static function checkForInvalidAttributes(tagData:IMXHXTagData, allowId:Bool):Void {
		for (attrData in tagData.attributeData) {
			if (allowId && attrData.name == ATTRIBUTE_ID) {
				continue;
			}
			reportError('Unknown field \'${attrData.name}\'', getAttributeNameSourceLocation(attrData));
		}
	}

	private static function createValueExprForDynamic(value:String):Expr {
		if (value == VALUE_TRUE || value == VALUE_FALSE) {
			var boolValue = value == VALUE_TRUE;
			return macro $v{boolValue};
		}
		if (~/^-?[0-9]+?$/.match(value)) {
			var intValue = Std.parseInt(value);
			var intAsFloatValue = Std.parseFloat(value);
			if (intValue != null && intValue == intAsFloatValue) {
				return macro $v{intValue};
			}
			var uintValue:UInt = Std.int(intAsFloatValue);
			return macro $v{uintValue};
		}
		if (~/^-?[0-9]+(\.[0-9]+)?(e\-?\d+)?$/.match(value)) {
			var floatValue = Std.parseFloat(value);
			return macro $v{floatValue};
		}
		if (~/^-?0x[0-9a-fA-F]+$/.match(value)) {
			var intValue = Std.parseInt(value);
			return macro $v{intValue};
		}
		if (value == VALUE_NAN) {
			return macro Math.NaN;
		} else if (value == VALUE_INFINITY) {
			return macro Math.POSITIVE_INFINITY;
		} else if (value == VALUE_NEGATIVE_INFINITY) {
			return macro Math.NEGATIVE_INFINITY;
		}
		// it can always be parsed as a string
		return macro $v{value};
	}

	private static function createDefaultValueExprForTypeSymbol(typeSymbol:IMXHXTypeSymbol, location:IMXHXSourceLocation):Expr {
		if (typeSymbol.pack.length == 0) {
			switch (typeSymbol.name) {
				case TYPE_BOOL:
					return macro false;
				case TYPE_EREG:
					return macro ~//;
				case TYPE_FLOAT:
					return macro Math.NaN;
				case TYPE_INT:
					return macro 0;
				case TYPE_STRING:
					if ((location is IMXHXTagData)) {
						var parentTag = cast(location, IMXHXTagData).parentTag;
						if (isLanguageTag(TAG_DECLARATIONS, parentTag)) {
							return macro null;
						}
					}
					return macro "";
				case TYPE_UINT:
					return macro 0;
				default:
					return macro null;
			}
		}
		return macro null;
	}

	private static function createValueExprForTypeSymbol(typeSymbol:IMXHXTypeSymbol, value:String, fromCdata:Bool, location:IMXHXSourceLocation):Expr {
		var current = typeSymbol;
		while ((current is IMXHXAbstractSymbol)) {
			var abstractSymbol:IMXHXAbstractSymbol = cast current;
			if (abstractSymbol.pack.length == 0 && abstractSymbol.name == TYPE_NULL) {
				var paramType = abstractSymbol.params[0];
				if (paramType != null) {
					current = paramType;
					continue;
				}
			} else if (!isLanguageTypeAssignableFromText(abstractSymbol)) {
				var fromTypes = abstractSymbol.from.filter(from -> {
					return isLanguageTypeAssignableFromText(from);
				});
				if (fromTypes.length > 0) {
					// TODO: if there's more than one, which is the best?
					current = fromTypes[0];
				}
			}
			break;
		}
		typeSymbol = current;

		if ((typeSymbol is IMXHXEnumSymbol)) {
			var enumSymbol:IMXHXEnumSymbol = cast typeSymbol;
			var trimmedValue = StringTools.trim(value);
			var enumField = Lambda.find(enumSymbol.fields, field -> field.name == trimmedValue);
			if (enumField != null) {
				if (enumSymbol.pack.length > 0) {
					var fieldExprParts = enumSymbol.pack.concat([enumSymbol.name, trimmedValue]);
					return macro $p{fieldExprParts};
				} else {
					var fieldExprParts = [enumSymbol.name, trimmedValue];
					return macro $p{fieldExprParts};
				}
			}
		}
		if (typeSymbol == null) {
			Context.fatalError('Fatal: Type symbol for value \'${value}\' not found', sourceLocationToContextPosition(location));
		}
		// when parsing text, string may be empty, but not other types
		if (typeSymbol.qname != TYPE_STRING && value.length == 0) {
			reportError('Value of type \'${typeSymbol.qname}\' cannot be empty', location);
		}
		if (typeSymbol.pack.length == 1 && typeSymbol.pack[0] == "haxe") {
			switch (typeSymbol.name) {
				case TYPE_FUNCTION:
					value = StringTools.trim(value);
					var typeParts = value.split(".");
					return macro $p{typeParts};
				default:
			}
		} else if (typeSymbol.pack.length == 0) {
			switch (typeSymbol.name) {
				case TYPE_BOOL:
					value = StringTools.trim(value);
					if (value == VALUE_TRUE || value == VALUE_FALSE) {
						var boolValue = value == VALUE_TRUE;
						return macro $v{boolValue};
					}
				case TYPE_CLASS:
					value = StringTools.trim(value);
					var typeParts = value.split(".");
					return macro $p{typeParts};
				case TYPE_EREG:
					value = StringTools.trim(value);
					if (value.length == 0) {
						return macro ~//;
					}
					// if not empty, must start with ~/ and have final / before flags
					if (!~/^~\/.*?\/[a-z]*$/.match(value)) {
						reportError('Cannot parse a value of type \'${typeSymbol.qname}\' from \'${value}\'', location);
						return null;
					}
					var endSlashIndex = value.lastIndexOf("/");
					var expression = value.substring(2, endSlashIndex);
					var flags = value.substr(endSlashIndex + 1);
					return macro new EReg($v{expression}, $v{flags});
				case TYPE_FLOAT:
					value = StringTools.trim(value);
					if (value == VALUE_NAN) {
						return macro Math.NaN;
					} else if (value == VALUE_INFINITY) {
						return macro Math.POSITIVE_INFINITY;
					} else if (value == VALUE_NEGATIVE_INFINITY) {
						return macro Math.NEGATIVE_INFINITY;
					}
					if (~/^-?0x[0-9a-fA-F]+$/.match(value)) {
						var floatValue = Std.parseInt(value);
						return macro $v{floatValue};
					}
					if (~/^-?[0-9]+(\.[0-9]+)?(e\-?\d+)?$/.match(value)) {
						var floatValue = Std.parseFloat(value);
						return macro $v{floatValue};
					}
				case TYPE_INT:
					value = StringTools.trim(value);
					var intValue = Std.parseInt(value);
					if (intValue != null) {
						return macro $v{intValue};
					}
				case TYPE_STRING:
					var inDeclarations = false;
					if ((location is IMXHXTagData)) {
						var parentTag = cast(location, IMXHXTagData).parentTag;
						inDeclarations = isLanguageTag(TAG_DECLARATIONS, parentTag);
					}
					// there are a couple of exceptions where the original
					// value is not used, and an alternate result is returned
					if (fromCdata && inDeclarations && value.length == 0) {
						// cdata is only modified when in mx:Declarations
						// and the length is 0
						return macro null;
					} else if (!fromCdata) {
						var trimmed = StringTools.trim(value);
						// if non-cdata consists of only whitespace,
						// return an empty string
						// unless it's in the mx:Declarations tag, then null
						if (trimmed.length == 0) {
							if (inDeclarations) {
								return macro null;
							} else {
								return macro $v{trimmed};
							}
						}
					}
					// otherwise, don't modify the original value
					return macro $v{value};
				case TYPE_UINT:
					value = StringTools.trim(value);
					if (~/^0x[0-9a-fA-F]+$/.match(value)) {
						var uintValue = Std.parseInt(value);
						return macro $v{uintValue};
					}
					if (~/^[0-9]+$/.match(value)) {
						var uintValue = Std.parseInt(value);
						var uintAsFloatValue = Std.parseFloat(value);
						if (uintValue != null && uintValue == uintAsFloatValue) {
							return macro $v{uintValue};
						}
						var uintAsIntValue:UInt = Std.int(uintAsFloatValue);
						return macro $v{uintAsIntValue};
					}
				default:
			}
		}
		reportError('Cannot parse a value of type \'${typeSymbol.qname}\' from \'${value}\'', location);
		return null;
	}

	private static function addFieldForID(id:String, type:ComplexType, location:IMXHXSourceLocation, generatedFields:Array<Field>):Void {
		var pos = sourceLocationToContextPosition(location);
		if (dispatchEventCallback == null) {
			generatedFields.push({
				name: id,
				pos: pos,
				kind: FVar(type),
				access: [APublic]
			});
			return;
		}
		var eventName = '${id}Changed';
		generatedFields.push({
			name: id,
			pos: pos,
			kind: FProp("default", "set", type),
			access: [APublic],
			meta: [{name: ":bindable", params: [macro $v{eventName}], pos: pos}]
		});
		var dispatcherExpr = macro this;
		var dispatchExpr = dispatchEventCallback(dispatcherExpr, eventName);
		generatedFields.push({
			name: 'set_${id}',
			pos: pos,
			kind: FFun({
				args: [{name: "value", type: type}],
				ret: type,
				expr: macro {
					this.$id = value;
					$dispatchExpr;
					return this.$id;
				}
			}),
			access: [APrivate]
		});
	}

	private static function inferTypeFromChildrenOfTag(tagData:IMXHXTagData):IMXHXTypeSymbol {
		var currentChild = tagData.getFirstChildTag(true);
		var resolvedChildType:IMXHXTypeSymbol = null;
		while (currentChild != null) {
			var currentChildSymbol = mxhxResolver.resolveTag(currentChild);
			var currentChildType:IMXHXTypeSymbol = null;
			if ((currentChildSymbol is IMXHXTypeSymbol)) {
				currentChildType = cast currentChildSymbol;
			}
			resolvedChildType = MXHXSymbolTools.getUnifiedType(currentChildType, resolvedChildType);
			if (resolvedChildType == null) {
				reportError('Arrays of mixed types are only allowed if the type is forced to Array<Dynamic>', currentChild);
			}
			currentChild = currentChild.getNextSiblingTag(true);
		}
		return resolvedChildType;
	}

	private static function addOuterDocumentField(typeDef:TypeDefinition, outerDocumentTypePath:TypePath):Void {
		typeDef.fields.push({
			name: FIELD_OUTER_DOCUMENT,
			pos: typeDef.pos,
			kind: FVar(TPath(outerDocumentTypePath)),
			access: [APublic],
			meta: [
				{
					name: META_NO_COMPLETION,
					pos: typeDef.pos
				}
			]
		});
		var staticOuterDocumentFieldName = '${typeDef.name}_${FIELD_DEFAULT_OUTER_DOCUMENT}';
		typeDef.fields.push({
			name: staticOuterDocumentFieldName,
			pos: typeDef.pos,
			kind: FVar(TPath(outerDocumentTypePath)),
			access: [APublic, AStatic],
			meta: [
				{
					name: META_NO_COMPLETION,
					pos: typeDef.pos
				}
			]
		});
		var existingInitFunction = Lambda.find(typeDef.fields, f -> f.name == INIT_FUNCTION_NAME);
		if (existingInitFunction != null) {
			switch (existingInitFunction.kind) {
				case FFun(f):
					var initExprs:Array<Expr> = [macro outerDocument = $i{staticOuterDocumentFieldName}, f.expr];
					f.expr = macro $b{initExprs};
					existingInitFunction.kind = FFun(f);
				default:
			}
		} else {
			#if (haxe_ver >= 4.3)
			Context.reportError('Cannot find method ${INIT_FUNCTION_NAME} on class ${typeDef.name}', typeDef.pos);
			#else
			Context.error('Cannot find method ${INIT_FUNCTION_NAME} on class ${typeDef.name}', typeDef.pos);
			#end
		}
	}

	private static function needsOverride(funcName:String, theClass:IMXHXClassSymbol):Bool {
		var currentClass = theClass;
		while (currentClass != null) {
			var field = Lambda.find(currentClass.fields, f -> f.name == funcName);
			if (field != null) {
				return field.isMethod;
			}
			if (currentClass.superClass == null) {
				currentClass = null;
			} else {
				currentClass = currentClass.superClass;
			}
		}
		return false;
	}

	private static function needsOverrideMacro(funcName:String, theClass:ClassType):Bool {
		var currentClass = theClass;
		while (currentClass != null) {
			var func = Lambda.find(currentClass.fields.get(), f -> f.name == funcName);
			if (func != null) {
				switch (func.kind) {
					case FMethod(k):
						return true;
					default:
						return false;
				}
			}
			if (currentClass.superClass == null) {
				currentClass = null;
			} else {
				currentClass = currentClass.superClass.t.get();
			}
		}
		return false;
	}

	private static function fieldExists(fieldName:String, theClass:IMXHXClassSymbol):Bool {
		var currentClass = theClass;
		while (currentClass != null) {
			var field = Lambda.find(currentClass.fields, f -> f.name == fieldName);
			if (field != null) {
				return !field.isMethod;
			}
			if (currentClass.superClass == null) {
				currentClass = null;
			} else {
				currentClass = currentClass.superClass;
			}
		}
		return false;
	}

	private static function errorTagNotSupported(tagData:IMXHXTagData):Void {
		reportError('Tag \'<${tagData.name}>\' is not supported by the \'${languageUri}\' namespace', tagData);
	}

	private static function errorAttributeNotSupported(attrData:IMXHXTagAttributeData):Void {
		reportError('Attribute \'${attrData.name}\' is not supported by the \'${languageUri}\' namespace', getAttributeNameSourceLocation(attrData));
	}

	private static function errorAttributeRequired(attrName:String, tagData:IMXHXTagData):Void {
		reportError('The <${tagData.name}> tag requires a \'${ATTRIBUTE_DESTINATION}\' attribute', tagData);
	}

	private static function errorStatesNotSupported(sourceLocation:IMXHXSourceLocation):Void {
		reportError('States are not supported by the \'${languageUri}\' namespace', sourceLocation);
	}

	private static function errorEventsNotSupported(sourceLocation:IMXHXSourceLocation):Void {
		reportError('Events are not supported by the \'${languageUri}\' namespace', sourceLocation);
	}

	private static function errorEventsNotConfigured(sourceLocation:IMXHXSourceLocation):Void {
		reportError('Adding event listeners has not been configured', sourceLocation);
	}

	private static function errorBindingNotSupported(sourceLocation:IMXHXSourceLocation):Void {
		reportError('Binding is not supported by the \'${languageUri}\' namespace', sourceLocation);
	}

	private static function errorTagUnexpected(tagData:IMXHXTagData):Void {
		reportError('Tag \'<${tagData.name}>\' is unexpected', tagData);
	}

	private static function errorTextUnexpected(textData:IMXHXTextData):Void {
		reportError('The \'${textData.content}\' value is unexpected', textData);
	}

	private static function errorAttributeUnexpected(attrData:IMXHXTagAttributeData):Void {
		reportError('Attribute \'${attrData.name}\' is unexpected', getAttributeNameSourceLocation(attrData));
	}

	private static function errorDuplicateField(fieldName:String, tagData:IMXHXTagData, sourceLocation:IMXHXSourceLocation):Void {
		reportError('Field \'${fieldName}\' is already specified for element \'${tagData.name}\'', sourceLocation);
	}

	private static function reportError(message:String, sourceLocation:IMXHXSourceLocation):Void {
		reportErrorForContextPosition(message, sourceLocationToContextPosition(sourceLocation));
	}

	private static function reportErrorForContextPosition(message:String, pos:Position):Void {
		#if (haxe_ver >= 4.3)
		Context.reportError(message, pos);
		#else
		Context.error(message, pos);
		#end
	}

	private static function errorUnexpected(unitData:IMXHXUnitData):Void {
		if ((unitData is IMXHXTagData)) {
			errorTagUnexpected(cast unitData);
			return;
		} else if ((unitData is IMXHXTextData)) {
			errorTextUnexpected(cast unitData);
			return;
		} else if ((unitData is IMXHXTagAttributeData)) {
			errorAttributeUnexpected(cast unitData);
			return;
		}
		reportError('MXHX data is unexpected', unitData);
	}

	private static function sourceLocationToContextPosition(location:IMXHXSourceLocation):Position {
		if (location.source == posInfos.file) {
			return Context.makePosition({
				min: posInfos.min + location.start,
				max: posInfos.min + location.end,
				file: posInfos.file
			});
		}
		return Context.makePosition({file: location.source, min: location.start, max: location.end});
	}

	private static function getAttributeNameSourceLocation(attrData:IMXHXTagAttributeData):IMXHXSourceLocation {
		if (attrData.valueStart == -1) {
			return attrData;
		}
		var attrNameStart = attrData.start;
		var attrNameEnd = attrData.valueStart - 2;
		if (attrNameEnd < attrNameStart) {
			attrNameEnd = attrNameStart;
		}
		return new CustomMXHXSourceLocation(attrNameStart, attrNameEnd, attrData.source);
	}

	private static function getAttributeValueSourceLocation(attrData:IMXHXTagAttributeData):IMXHXSourceLocation {
		if (attrData.valueStart == -1 || attrData.valueEnd == -1) {
			return attrData;
		}
		return new CustomMXHXSourceLocation(attrData.valueStart, attrData.valueEnd, attrData.source);
	}

	private static function resolveFilePath(filePath:String):String {
		if (Path.isAbsolute(filePath)) {
			return filePath;
		}
		var modulePath = Context.getPosInfos(Context.currentPos()).file;
		if (!Path.isAbsolute(modulePath)) {
			modulePath = FileSystem.absolutePath(modulePath);
		}
		modulePath = Path.directory(modulePath);
		return Path.join([modulePath, filePath]);
	}

	private static function loadMXHXFile(filePath:String):String {
		filePath = resolveFilePath(filePath);
		if (!FileSystem.exists(filePath)) {
			throw 'MXHX component file not found: ${filePath}';
		}
		return File.getContent(filePath);
	}
	#end
}

private class CustomMXHXSourceLocation implements IMXHXSourceLocation {
	public var start:Int;
	public var end:Int;
	public var source:String;

	public function new(start:Int, end:Int, source:String) {
		this.start = start;
		this.end = end;
		this.source = source;
	}
}

private class ModelObject {
	public var fields:Map<String, Array<ModelObject>> = [];
	public var strongFields:Bool = false;
	public var text:Array<IMXHXTextData> = [];
	public var value:String;
	public var location:IMXHXSourceLocation;

	public function new(?value:String) {
		this.value = value;
	}
}
