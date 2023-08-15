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
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.PositionTools;
import haxe.macro.Type;
import haxe.macro.Type.ClassType;
import haxe.macro.TypeTools;
import mxhx.parser.MXHXParser;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
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
	private static final PROPERTY_ID = "id";
	private static final PROPERTY_TYPE = "type";
	private static final PROPERTY_XMLNS = "xmlns";
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
	private static final TYPE_INT = "Int";
	private static final TYPE_NULL = "Null";
	private static final TYPE_STRING = "String";
	private static final TYPE_UINT = "UInt";
	private static final TYPE_XML = "Xml";
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
	private static final LANGUAGE_MAPPINGS_2024 = [
		// @:formatter:off
		TYPE_ARRAY => TYPE_ARRAY,
		TYPE_BOOL => TYPE_BOOL,
		TYPE_CLASS => TYPE_CLASS,
		TYPE_DATE => TYPE_DATE,
		TYPE_EREG => TYPE_EREG,
		TYPE_FLOAT => TYPE_FLOAT,
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
		TAG_BINDING,
		TAG_DEFINITION,
		TAG_DESIGN_LAYER,
		TAG_LIBRARY,
		TAG_METADATA,
		TAG_MODEL,
		TAG_PRIVATE,
		TAG_REPARENT,
		TAG_SCRIPT,
		TAG_STYLE,
		// @:formatter:on
	];
	private static var componentCounter = 0;
	// float can hold larger integers than int
	private static var objectCounter:Float = 0.0;
	private static var posInfos:{min:Int, max:Int, file:String};
	private static var languageUri:String = null;
	private static var mxhxResolver:MXHXMacroResolver;
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
		createResolver();
		var mxhxParser = new MXHXParser(mxhxText, posInfos.file);
		var mxhxData = mxhxParser.parse();
		if (mxhxData.problems.length > 0) {
			for (problem in mxhxData.problems) {
				reportError(problem.message, sourceLocationToContextPosition(problem));
			}
			return null;
		}

		var superClass = localClass.superClass;
		var rootTag = mxhxData.rootTag;
		var resolvedTag = mxhxResolver.resolveTag(rootTag);
		var resolvedType:BaseType = null;
		if (resolvedTag != null) {
			switch (resolvedTag) {
				case ClassSymbol(c, params):
					resolvedType = c;
				case AbstractSymbol(a, params):
					resolvedType = a;
				case EnumSymbol(e, params):
					resolvedType = e;
				default:
			}
		}
		if (resolvedType == null) {
			reportError('Could not resolve super class for \'${localClass.name}\' from tag \'<${rootTag.name}>\'', localClass.pos);
			return null;
		}
		if (!isObjectTag(rootTag)) {
			var expectedSuperClass = resolvedType.module;
			if (superClass == null || Std.string(superClass.t) != expectedSuperClass) {
				reportError('Class ${localClass.name} must extend ${expectedSuperClass}', localClass.pos);
				return null;
			}
		}

		var buildFields = Context.getBuildFields();
		var localTypePath = {name: localClass.name, pack: localClass.pack};
		handleRootTag(mxhxData.rootTag, INIT_FUNCTION_NAME, localTypePath, buildFields);
		if (localClass.superClass != null) {
			var superClass = localClass.superClass.t.get();
			var initFunc = Lambda.find(buildFields, f -> f.name == INIT_FUNCTION_NAME);
			if (initFunc != null && needsOverride(initFunc.name, superClass)) {
				initFunc.access.push(AOverride);
				switch (initFunc.kind) {
					case FFun(f):
						var oldExpr = f.expr;
						f.expr = macro {
							super.$INIT_FUNCTION_NAME();
							$oldExpr;
						}
					default:
						reportError('Cannot find method ${INIT_FUNCTION_NAME} on class ${superClass.name}', sourceLocationToContextPosition(rootTag));
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
		}
		if (typeDef == null) {
			var mxhxText = loadMXHXFile(filePath);
			if (typePath == null) {
				var name = 'MXHXComponent_${componentCounter}';
				componentCounter++;
				typePath = {name: name, pack: PACKAGE_RESERVED};
			}
			createResolver();
			typeDef = createTypeDefinitionFromString(mxhxText, typePath);
			mxhxResolver = null;
			FILE_PATH_TO_TYPE_DEFINITION.set(filePath, typeDef);
		}
		if (typeDef == null) {
			return macro null;
		}
		Context.defineType(typeDef);
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
		createResolver();
		var typeDef = createTypeDefinitionFromString(mxhxText, typePath);
		mxhxResolver = null;
		if (typeDef == null) {
			return macro null;
		}
		Context.defineType(typeDef);
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
			reportError('Error parsing invalid XML in manifest file: ${manifestPath}', Context.currentPos());
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

	private static function createTypeDefinitionFromString(mxhxText:String, typePath:TypePath):TypeDefinition {
		var mxhxParser = new MXHXParser(mxhxText, posInfos.file);
		var mxhxData = mxhxParser.parse();
		if (mxhxData.problems.length > 0) {
			for (problem in mxhxData.problems) {
				reportError(problem.message, sourceLocationToContextPosition(problem));
			}
			return null;
		}
		var typeDef:TypeDefinition = createTypeDefinitionFromTagData(mxhxData.rootTag, typePath);
		if (typeDef == null) {
			return null;
		}
		return typeDef;
	}

	private static function createTypeDefinitionFromTagData(rootTag:IMXHXTagData, typePath:TypePath):TypeDefinition {
		var buildFields:Array<Field> = [];
		var resolvedTag = handleRootTag(rootTag, INIT_FUNCTION_NAME, typePath, buildFields);

		var resolvedType:BaseType = null;
		var resolvedClass:ClassType = null;
		if (resolvedTag != null) {
			switch (resolvedTag) {
				case ClassSymbol(c, params):
					resolvedClass = c;
					resolvedType = c;
				case AbstractSymbol(a, params):
					resolvedClass = null;
					resolvedType = a;
				case EnumSymbol(e, params):
					resolvedClass = null;
					resolvedType = e;
				default:
					resolvedClass = null;
					resolvedType = null;
			}
		}

		var componentName = typePath.name;
		var typeDef:TypeDefinition = null;
		if (resolvedClass != null) {
			var superClassTypePath = {name: resolvedClass.name, pack: resolvedClass.pack};
			typeDef = macro class $componentName extends $superClassTypePath {};
		} else if (resolvedType != null) {
			if (!isObjectTag(rootTag)) {
				reportError('Tag ${rootTag.name} cannot be used as a base class', sourceLocationToContextPosition(rootTag));
			}
			typeDef = macro class $componentName {};
		} else {
			reportError('Tag ${rootTag.name} could not be resolved to a class', sourceLocationToContextPosition(rootTag));
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
					reportError('Cannot find method ${INIT_FUNCTION_NAME} on class ${resolvedClass.name}', sourceLocationToContextPosition(rootTag));
			}
		}
		for (buildField in buildFields) {
			if (resolvedClass == null || !fieldExists(buildField.name, resolvedClass)) {
				typeDef.fields.push(buildField);
			}
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

	private static function handleRootTag(tagData:IMXHXTagData, initFunctionName:String, outerDocumentTypePath:TypePath, buildFields:Array<Field>):MXHXSymbol {
		var resolvedTag = mxhxResolver.resolveTag(tagData);
		if (resolvedTag == null) {
			errorTagUnexpected(tagData);
			return null;
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
							reportError("Only one language namespace may be used in an MXHX document.", sourceLocationToContextPosition(attrData));
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
		handleAttributesOfInstanceTag(tagData, resolvedTag, KEYWORD_THIS, bodyExprs, attributeAndChildNames);
		handleChildUnitsOfInstanceTag(tagData, resolvedTag, KEYWORD_THIS, outerDocumentTypePath, generatedFields, bodyExprs, attributeAndChildNames);
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
			if (resolvedTag != null) {
				switch (resolvedTag) {
					case ClassSymbol(c, params):
						if (!isObjectTag(tagData)) {
							constructorExprs.unshift(macro super());
						};
					default:
				}
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
		var idAttr = tagData.getAttributeData(PROPERTY_ID);
		if (idAttr != null) {
			reportError('id attribute is not allowed on the root tag of a component.', sourceLocationToContextPosition(idAttr));
		}
		return resolvedTag;
	}

	private static function handleAttributesOfInstanceTag(tagData:IMXHXTagData, parentSymbol:MXHXSymbol, targetIdentifier:String, initExprs:Array<Expr>,
			attributeAndChildNames:Map<String, Bool>):Void {
		for (attribute in tagData.attributeData) {
			handleAttributeOfInstanceTag(attribute, parentSymbol, targetIdentifier, initExprs, attributeAndChildNames);
		}
	}

	private static function handleAttributeOfInstanceTag(attrData:IMXHXTagAttributeData, parentSymbol:MXHXSymbol, targetIdentifier:String,
			initExprs:Array<Expr>, attributeAndChildNames:Map<String, Bool>):Void {
		if (attrData.name == PROPERTY_XMLNS || attrData.prefix == PROPERTY_XMLNS) {
			// skip xmlns="" or xmlns:prefix=""
			return;
		}
		if (attributeAndChildNames.exists(attrData.name)) {
			errorDuplicateField(attrData.name, attrData.parentTag, attrData);
			return;
		}
		attributeAndChildNames.set(attrData.name, true);
		if (attrData.stateName != null) {
			errorStatesNotSupported(attrData);
			return;
		}
		var resolved = mxhxResolver.resolveAttribute(attrData);
		if (resolved == null) {
			var isAnyOrDynamic = switch (parentSymbol) {
				case AbstractSymbol(a, params): a.pack.length == 0 && (a.name == TYPE_ANY || a.name == TYPE_DYNAMIC);
				default: null;
			}
			if (isAnyOrDynamic && attrData.name != PROPERTY_ID) {
				var valueExpr = createValueExprForDynamic(attrData.rawValue);
				var setExpr = macro Reflect.setField($i{targetIdentifier}, $v{attrData.shortName}, ${valueExpr});
				initExprs.push(setExpr);
				return;
			}
			if (attrData.name == PROPERTY_ID) {
				// id is a special attribute that doesn't need to resolve
				return;
			}
			if (attrData.name == PROPERTY_TYPE) {
				// type is a special attribute of Array that doesn't need to resolve
				switch (parentSymbol) {
					case ClassSymbol(c, params):
						if (c.pack.length == 0 && c.name == TYPE_ARRAY) {
							return;
						}
					default:
				}
			}
			errorAttributeUnexpected(attrData);
			return;
		}
		switch (resolved) {
			case EventSymbol(e, t):
				if (languageUri == LANGUAGE_URI_BASIC_2024) {
					errorEventsNotSupported(attrData);
					return;
				} else if (addEventListenerCallback == null) {
					errorEventsNotConfigured(attrData);
					return;
				} else {
					var dispatcherExpr = macro $i{targetIdentifier};
					var eventName = MXHXMacroTools.getEventName(e);
					var listenerExpr = Context.parse(attrData.rawValue, sourceLocationToContextPosition(attrData));
					var addEventExpr = addEventListenerCallback(dispatcherExpr, eventName, listenerExpr);
					initExprs.push(addEventExpr);
				}
			case FieldSymbol(f, t):
				var valueExpr:Expr = null;

				var baseType:BaseType = null;
				var enumType:EnumType = null;
				var abstractType:AbstractType = null;
				var currentType = f.type;
				if (currentType != null) {
					while (true) {
						switch (currentType) {
							case TInst(t, params):
								baseType = t.get();
								break;
							case TAbstract(t, params):
								abstractType = t.get();
								if (abstractType.name == TYPE_NULL) {
									abstractType = null;
									currentType = params[0];
								} else {
									baseType = abstractType;
									break;
								}
							case TEnum(t, params):
								enumType = t.get();
								baseType = enumType;
								break;
							case TLazy(f):
								currentType = f();
							default:
								break;
						}
					}
				}
				if (abstractType != null) {
					if (!isLanguageTypeAssignableFromText(abstractType)) {
						for (from in abstractType.from) {
							var fromBaseType:BaseType = null;
							var fromEnumType:EnumType = null;
							var fromAbstractType:AbstractType = null;
							var currentFromType = from.t;
							if (currentFromType != null) {
								while (true) {
									switch (currentFromType) {
										case TInst(t, params):
											fromBaseType = t.get();
											break;
										case TAbstract(t, params):
											fromAbstractType = t.get();
											if (fromAbstractType.name == TYPE_NULL) {
												fromAbstractType = null;
												currentFromType = params[0];
											} else {
												fromBaseType = fromAbstractType;
												break;
											}
										case TEnum(t, params):
											fromEnumType = t.get();
											fromBaseType = fromEnumType;
											break;
										case TLazy(f):
											currentFromType = f();
										default:
											break;
									}
								}
							}
							if (isLanguageTypeAssignableFromText(fromBaseType)) {
								baseType = fromBaseType;
								abstractType = fromAbstractType;
								enumType = fromEnumType;
							}
						}
					}
				}
				var fieldName = f.name;
				var destination = macro $i{targetIdentifier}.$fieldName;
				valueExpr = handleTextContentAsExpr(attrData.rawValue, baseType, enumType, attrData.valueStart, getAttributeValueSourceLocation(attrData));
				if (dataBindingCallback != null && textContentContainsBinding(attrData.rawValue)) {
					var bindingExpr = dataBindingCallback(valueExpr, destination, macro this);
					initExprs.push(bindingExpr);
				} else {
					var setExpr = macro $destination = ${valueExpr};
					initExprs.push(setExpr);
				}
			default:
				errorAttributeUnexpected(attrData);
		}
	}

	private static function handleDateTag(tagData:IMXHXTagData, generatedFields:Array<Field>):Expr {
		var intType = Context.getType(TYPE_INT);
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
						errorDuplicateField(FIELD_FULL_YEAR, tagData, attrData);
					}
					fullYear = createValueExprForType(intType, attrData.rawValue, false, attrData);
				case FIELD_MONTH:
					hasCustom = true;
					if (month != null) {
						errorDuplicateField(FIELD_MONTH, tagData, attrData);
					}
					month = createValueExprForType(intType, attrData.rawValue, false, attrData);
				case FIELD_DATE:
					hasCustom = true;
					if (date != null) {
						errorDuplicateField(FIELD_DATE, tagData, attrData);
					}
					date = createValueExprForType(intType, attrData.rawValue, false, attrData);
				case FIELD_HOURS:
					hasCustom = true;
					if (hours != null) {
						errorDuplicateField(FIELD_HOURS, tagData, attrData);
					}
					hours = createValueExprForType(intType, attrData.rawValue, false, attrData);
				case FIELD_MINUTES:
					hasCustom = true;
					if (minutes != null) {
						errorDuplicateField(FIELD_MINUTES, tagData, attrData);
					}
					minutes = createValueExprForType(intType, attrData.rawValue, false, attrData);
				case FIELD_SECONDS:
					hasCustom = true;
					if (seconds != null) {
						errorDuplicateField(FIELD_SECONDS, tagData, attrData);
					}
					seconds = createValueExprForType(intType, attrData.rawValue, false, attrData);
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
		var idAttr = tagData.getAttributeData(PROPERTY_ID);
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
		var xmlDoc = Xml.createDocument();
		var current = tagData.getFirstChildUnit();
		var parentStack:Array<Xml> = [xmlDoc];
		var tagDataStack:Array<IMXHXTagData> = [];
		while (current != null) {
			if ((current is IMXHXTagData)) {
				var tagData:IMXHXTagData = cast current;
				if (tagData.isOpenTag()) {
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
					case Text | Whitespace: Xml.createPCData(textData.content);
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
				// ust added a tag to the stack, so read its children
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
		var idAttr = tagData.getAttributeData(PROPERTY_ID);
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

	private static function handleComponentTag(tagData:IMXHXTagData, assignedToType:Type, outerDocumentTypePath:TypePath, generatedFields:Array<Field>):Expr {
		var componentName = 'MXHXComponent_${componentCounter}';
		var functionName = 'createMXHXInlineComponent_${componentCounter}';
		componentCounter++;
		var typePath = {name: componentName, pack: PACKAGE_RESERVED};
		var typeDef = createTypeDefinitionFromTagData(tagData.getFirstChildTag(true), typePath);
		if (typeDef == null) {
			return macro null;
		}

		var typePos = sourceLocationToContextPosition(tagData);
		typeDef.fields.push({
			name: "outerDocument",
			pos: typePos,
			kind: FVar(TPath(outerDocumentTypePath)),
			access: [APublic],
			meta: [
				{
					name: META_NO_COMPLETION,
					pos: typePos
				}
			]
		});
		var staticOuterDocumentFieldName = '${componentName}_defaultOuterDocument';
		typeDef.fields.push({
			name: staticOuterDocumentFieldName,
			pos: typePos,
			kind: FVar(TPath(outerDocumentTypePath)),
			access: [APublic, AStatic],
			meta: [
				{
					name: META_NO_COMPLETION,
					pos: typePos
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
		}
		Context.defineType(typeDef);

		// TODO: allow customization of returned expression based on the type
		// that is being assigned to

		var typeParts = typeDef.pack.copy();
		typeParts.push(typeDef.name);
		var assignmentParts = typeParts.copy();
		assignmentParts.push(staticOuterDocumentFieldName);
		var bodyExpr = macro {
			$p{assignmentParts} = this;
			return $p{typeParts};
		};

		generatedFields.push({
			name: functionName,
			pos: typePos,
			kind: FFun({
				args: [],
				ret: TypeTools.toComplexType(assignedToType),
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
		return macro $i{functionName}();
	}

	private static function handleInstanceTag(tagData:IMXHXTagData, assignedToType:Type, outerDocumentTypePath:TypePath, generatedFields:Array<Field>):Expr {
		if (isObjectTag(tagData)) {
			reportError('Tag \'<${tagData.name}>\' must only be used as a base class. Did you mean \'<${tagData.prefix}:${TAG_STRUCT}/>\'?',
				sourceLocationToContextPosition(tagData));
		}
		var resolvedTag = mxhxResolver.resolveTag(tagData);
		if (resolvedTag == null) {
			errorTagUnexpected(tagData);
			return null;
		}
		var resolvedType:BaseType = null;
		var resolvedTypeParams:Array<Type> = null;
		var resolvedClass:ClassType = null;
		var resolvedEnum:EnumType = null;
		var isArray = false;
		if (resolvedTag != null) {
			switch (resolvedTag) {
				case ClassSymbol(c, params):
					resolvedType = c;
					resolvedTypeParams = params;
					resolvedClass = c;
					resolvedEnum = null;
					isArray = resolvedType.pack.length == 0 && resolvedType.name == TYPE_ARRAY;
				case AbstractSymbol(a, params):
					resolvedType = a;
					resolvedTypeParams = params;
					resolvedClass = null;
					resolvedEnum = null;
					isArray = false;
				case EnumSymbol(e, params):
					resolvedType = e;
					resolvedTypeParams = params;
					resolvedClass = null;
					resolvedEnum = e;
					isArray = false;
				case EnumFieldSymbol(f, t):
					switch (t) {
						case EnumSymbol(e, params):
							resolvedType = e;
							resolvedTypeParams = params;
							resolvedClass = null;
							resolvedEnum = e;
							isArray = false;
						default:
							errorTagUnexpected(tagData);
					}
					return createInitExpr(tagData.parentTag, resolvedType, resolvedEnum, outerDocumentTypePath, generatedFields);
				default:
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
		handleAttributesOfInstanceTag(tagData, resolvedTag, localVarName, setFieldExprs, attributeAndChildNames);
		handleChildUnitsOfInstanceTag(tagData, resolvedTag, localVarName, outerDocumentTypePath, generatedFields, setFieldExprs, attributeAndChildNames);

		var instanceTypePath:TypePath = null;
		if (resolvedType == null) {
			// this shouldn't happen
			instanceTypePath = {name: TYPE_DYNAMIC, pack: []};
		} else {
			var qname = resolvedType.name;
			if (resolvedType.pack.length > 0) {
				qname = resolvedType.pack.join(".") + "." + qname;
			}
			if (qname != resolvedType.module) {
				instanceTypePath = {name: resolvedType.module.split(".").pop(), pack: resolvedType.pack, sub: resolvedType.name};
			} else {
				instanceTypePath = {name: resolvedType.name, pack: resolvedType.pack};
			}
			if (isArray) {
				var paramType:ComplexType = null;
				if (resolvedTypeParams.length > 0) {
					switch (resolvedTypeParams[0]) {
						case null:
							// if null, the type was explicit, but could not be resolved
							var attrData = tagData.getAttributeData(PROPERTY_TYPE);
							if (attrData != null) {
								reportError('The type parameter \'${attrData.rawValue}\' for tag \'<${tagData.name}>\' cannot be resolved',
									sourceLocationToContextPosition(attrData));
							} else {
								reportError('Resolved tag \'<${tagData.name}>\' to type \'${resolvedType.name}\', but type parameter is missing',
									sourceLocationToContextPosition(attrData));
							}
						case TMono(t):
							// if TMono, the type was not specified
							if (t.get() == null && assignedToType != null) {
								// if this is being assigned to a field, we can
								// infer the correct type from the field's type
								switch (assignedToType) {
									case TInst(t, params):
										var classType = t.get();
										if (classType.pack.length == 0 && classType.name == TYPE_ARRAY && params.length > 0) {
											var isTypeParameter = false;
											switch (params[0]) {
												case TInst(t, params):
													var paramClassType = t.get();
													switch (paramClassType.kind) {
														case KTypeParameter(constraints):
															isTypeParameter = true;
														default:
													}
												default:
											}
											if (!isTypeParameter) {
												paramType = TypeTools.toComplexType(params[0]);
											}
										}
									default:
								}
							}
							if (paramType == null) {
								// finally, try to infer the correct type from
								// the items in the array
								var inferredType = inferTypeFromChildrenOfTag(tagData);
								if (inferredType != null) {
									paramType = TypeTools.toComplexType(inferredType);
								}
							}
						default:
							paramType = TypeTools.toComplexType(resolvedTypeParams[0]);
					}
					if (paramType == null) {
						paramType = TPath({name: TYPE_DYNAMIC, pack: []});
					}
					instanceTypePath.params = [TPType(paramType)];
				}
			}
		}

		var returnTypePath = instanceTypePath;
		if (resolvedType != null
			&& resolvedType.params.length > 0
			&& (instanceTypePath.params == null || resolvedType.params.length != instanceTypePath.params.length)) {
			// last resort: set return type and field type to Dynamic
			returnTypePath = {name: TYPE_DYNAMIC, pack: []};
		}
		var id:String = null;
		var idAttr = tagData.getAttributeData(PROPERTY_ID);
		if (idAttr != null) {
			id = idAttr.rawValue;
		}
		var setIDExpr:Expr = null;
		if (id != null) {
			addFieldForID(id, TPath(returnTypePath), idAttr, generatedFields);
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
				ret: TPath(returnTypePath),
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

	private static function handleInstanceTagEnumValue(tagData:IMXHXTagData, t:BaseType, generatedFields:Array<Field>):Expr {
		var initExpr = createEnumFieldInitExpr(tagData, null, generatedFields);
		var idAttr = tagData.getAttributeData(PROPERTY_ID);
		if (idAttr != null) {
			var id = idAttr.rawValue;
			var typePath:TypePath = {pack: t.pack, name: t.name, params: null};
			if (t.pack.length == 0 && t.name == TYPE_CLASS) {
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
		switch (resolvedTag) {
			case EnumFieldSymbol(f, t):
				var resolvedEnum:EnumType;
				switch (t) {
					case EnumSymbol(e, params):
						resolvedEnum = e;
					default:
				}
				switch (f.type) {
					case TEnum(t, params):
						var fieldName = f.name;
						if (resolvedEnum != null) {
							var resolvedEnumName = resolvedEnum.name;
							if (resolvedEnum.pack.length > 0) {
								var fieldExprParts = resolvedEnum.pack.concat([resolvedEnum.name, fieldName]);
								return macro $p{fieldExprParts};
							}
						}
						return macro $i{fieldName};
					case TFun(args, ret):
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
								var valueExpr = createValueExprForType(arg.t, attrData.rawValue, false, attrData);
								initArgs.push(valueExpr);
							} else if (tagLookup.exists(argName)) {
								var grandChildTag = tagLookup.get(argName);
								tagLookup.remove(argName);
								var valueExpr = createValueExprForFieldTag(grandChildTag, null, null, arg.t, outerDocumentTypePath, generatedFields);
								initArgs.push(valueExpr);
							} else if (arg.opt) {
								initArgs.push(macro null);
							} else {
								reportError('Value \'${arg.name}\' is required by tag \'<${childTag.name}>\'', sourceLocationToContextPosition(childTag));
							}
						}
						for (tagName => grandChildTag in tagLookup) {
							errorTagUnexpected(grandChildTag);
						}
						for (attrName => attrData in attrLookup) {
							errorAttributeUnexpected(attrData);
						}
						var fieldName = f.name;
						if (resolvedEnum != null) {
							var resolvedEnumName = resolvedEnum.name;
							if (resolvedEnum.pack.length > 0) {
								var fieldExprParts = resolvedEnum.pack.concat([resolvedEnum.name, fieldName]);
								return macro $p{fieldExprParts}($a{initArgs});
							}
						}
						return macro $i{fieldName}($a{initArgs});
					default:
						errorTagUnexpected(childTag);
				}
			default:
				errorUnexpected(childTag);
				return null;
		}
		return null;
	}

	private static function handleInstanceTagAssignableFromText(tagData:IMXHXTagData, t:BaseType, e:EnumType, generatedFields:Array<Field>):Expr {
		var initExpr:Expr = null;
		var child = tagData.getFirstChildUnit();
		var bindingTextData:IMXHXTextData = null;
		if (child != null && (child is IMXHXTextData) && child.getNextSiblingUnit() == null) {
			var textData = cast(child, IMXHXTextData);
			if (textData.textType == Text && isLanguageTypeAssignableFromText(t)) {
				initExpr = handleTextContentAsExpr(textData.content, t, e, null, textData);
				bindingTextData = textData;
			}
		}
		if (initExpr == null) {
			var pendingText:String = null;
			var pendingTextIncludesCData = false;
			do {
				if (child == null) {
					if (initExpr != null) {
						errorTagUnexpected(tagData);
					} else {
						initExpr = createDefaultValueExprForBaseType(t, tagData);
					}
					// no more children
					break;
				} else if ((child is IMXHXTextData)) {
					var textData:IMXHXTextData = cast child;
					switch (textData.textType) {
						case Text:
							var content = textData.content;
							if (textContentContainsBinding(content)) {
								reportError('Binding is not supported here', sourceLocationToContextPosition(textData));
							}
							if (pendingText == null) {
								pendingText = "";
							}
							pendingText += content;
						case CData:
							if (pendingText == null) {
								pendingText = "";
							}
							pendingText += textData.content;
							pendingTextIncludesCData = true;
						case Whitespace:
							if (t.name == TYPE_STRING && t.pack.length == 0) {
								if (pendingText == null) {
									pendingText = "";
								}
								pendingText += textData.content;
							}
						default:
							if (!canIgnoreTextData(textData)) {
								errorTextUnexpected(textData);
								break;
							}
					}
				} else {
					errorUnexpected(child);
				}
				child = child.getNextSiblingUnit();
				if (child == null && pendingText != null) {
					if (e != null) {
						var value = StringTools.trim(pendingText);
						initExpr = macro $i{value};
					} else {
						initExpr = createValueExprForBaseType(t, pendingText, pendingTextIncludesCData, tagData);
					}
				}
			} while (child != null || initExpr == null);
		}
		var idAttr = tagData.getAttributeData(PROPERTY_ID);
		if (idAttr != null) {
			var id = idAttr.rawValue;
			var destination = macro this.$id;
			var typePath:TypePath = {pack: t.pack, name: t.name, params: null};
			if (t.pack.length == 0 && t.name == TYPE_CLASS) {
				typePath.params = [TPType(TPath({pack: [], name: TYPE_DYNAMIC}))];
			}
			addFieldForID(id, TPath(typePath), idAttr, generatedFields);
			if (bindingTextData != null && dataBindingCallback != null && textContentContainsBinding(bindingTextData.content)) {
				initExpr = dataBindingCallback(initExpr, destination, macro this);
			} else {
				initExpr = macro $destination = $initExpr;
			}
		}
		return initExpr;
	}

	private static function handleTextContentAsExpr(text:String, baseType:BaseType, enumType:EnumType, textStartOffset:Int,
			sourceLocation:IMXHXSourceLocation):Expr {
		var expr:Expr = null;
		var startIndex = 0;
		var pendingText:String = "";
		do {
			var bindingStartIndex = text.indexOf("{", startIndex);
			if (bindingStartIndex == -1) {
				if (expr == null && pendingText.length == 0) {
					if (enumType != null) {
						if (enumType.names.indexOf(text) != -1) {
							return macro $i{text};
						}
					}
					return createValueExprForBaseType(baseType, text, false, sourceLocation);
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

	private static function createInitExpr(tagData:IMXHXTagData, t:BaseType, e:EnumType, outerDocumentTypePath:TypePath, generatedFields:Array<Field>):Expr {
		var initExpr:Expr = null;
		if (e != null) {
			if (!tagContainsOnlyText(tagData)) {
				initExpr = handleInstanceTagEnumValue(tagData, t, generatedFields);
			} else {
				initExpr = handleInstanceTagAssignableFromText(tagData, t, e, generatedFields);
			}
		} else if (isLanguageTypeAssignableFromText(t)) {
			initExpr = handleInstanceTagAssignableFromText(tagData, t, e, generatedFields);
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
		var resolvedTag = mxhxResolver.resolveTag(tagData);
		if (resolvedTag == null) {
			errorTagUnexpected(tagData);
			return;
		} else {
			switch (resolvedTag) {
				case ClassSymbol(c, params):
					var initExpr = createInitExpr(tagData, c, null, outerDocumentTypePath, generatedFields);
					initExprs.push(initExpr);
					return;
				case AbstractSymbol(a, params):
					var initExpr = createInitExpr(tagData, a, null, outerDocumentTypePath, generatedFields);
					initExprs.push(initExpr);
					return;
				case EnumSymbol(e, params):
					var initExpr = createInitExpr(tagData, e, e, outerDocumentTypePath, generatedFields);
					initExprs.push(initExpr);
					return;
				default:
					errorTagUnexpected(tagData);
					return;
			}
		}
	}

	private static function handleChildUnitsOfInstanceTag(tagData:IMXHXTagData, parentSymbol:MXHXSymbol, targetIdentifier:String,
			outerDocumentTypePath:TypePath, generatedFields:Array<Field>, initExprs:Array<Expr>, attributeAndChildNames:Map<String, Bool>):Void {
		var parentType:BaseType = null;
		var parentClass:ClassType = null;
		var parentEnum:EnumType = null;
		var isArray = false;
		if (parentSymbol != null) {
			switch (parentSymbol) {
				case ClassSymbol(c, params):
					parentType = c;
					parentClass = c;
					parentEnum = null;
					isArray = c.pack.length == 0 && (c.name == TYPE_ARRAY);
				case AbstractSymbol(a, params):
					parentType = a;
					parentClass = null;
					parentEnum = null;
				case EnumSymbol(e, params):
					parentType = e;
					parentClass = null;
					parentEnum = e;
				default:
			}
		}

		if (parentEnum != null || isLanguageTypeAssignableFromText(parentType)) {
			initExprs.push(createInitExpr(tagData, parentType, parentEnum, outerDocumentTypePath, generatedFields));
			return;
		}

		var defaultProperty:String = null;
		var currentClass = parentClass;
		while (currentClass != null) {
			defaultProperty = getDefaultProperty(currentClass);
			if (defaultProperty != null) {
				break;
			}
			var superClass = currentClass.superClass;
			if (superClass == null) {
				break;
			}
			currentClass = superClass.t.get();
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

	private static function handleChildUnitsOfInstanceTagWithDefaultProperty(tagData:IMXHXTagData, parentSymbol:MXHXSymbol, defaultProperty:String,
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
		var field = switch (resolvedField) {
			case FieldSymbol(f, t): f;
			case null: null;
			default: null;
		}
		if (field == null) {
			Context.fatalError('Default property \'${defaultProperty}\' not found for tag \'<${tagData.name}>\'', sourceLocationToContextPosition(tagData));
			return;
		}

		var fieldName = field.name;
		attributeAndChildNames.set(fieldName, true);

		var valueExpr = createValueExprForFieldTag(tagData, defaultChildren, field, null, outerDocumentTypePath, generatedFields);
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
				reportError('Tag \'<${tagData.name}>\' must be a child of the root element', sourceLocationToContextPosition(tagData));
				return false;
			}
		}
		return true;
	}

	private static function handleChildUnitOfInstanceTag(unitData:IMXHXUnitData, parentSymbol:MXHXSymbol, targetIdentifier:String,
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
			}
			var resolvedTag = mxhxResolver.resolveTag(tagData);
			if (resolvedTag == null) {
				var isAnyOrDynamic = switch (parentSymbol) {
					case AbstractSymbol(a, params): a.pack.length == 0 && (a.name == TYPE_ANY || a.name == TYPE_DYNAMIC);
					case null: false;
					default: false;
				}
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
				switch (resolvedTag) {
					case EventSymbol(e, t):
						if (languageUri == LANGUAGE_URI_BASIC_2024) {
							errorEventsNotSupported(tagData);
							return;
						} else {
							var eventName = MXHXMacroTools.getEventName(e);
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
					case FieldSymbol(f, t):
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
						var fieldName = f.name;
						var valueExpr = createValueExprForFieldTag(tagData, null, f, null, outerDocumentTypePath, generatedFields);
						var initExpr = macro $i{targetIdentifier}.$fieldName = ${valueExpr};
						initExprs.push(initExpr);
						return;
					case ClassSymbol(c, params):
						if (defaultChildren == null) {
							errorTagUnexpected(tagData);
							return;
						}
						defaultChildren.push(unitData);
						return;
					case AbstractSymbol(a, params):
						if (defaultChildren == null) {
							errorTagUnexpected(tagData);
							return;
						}
						defaultChildren.push(unitData);
						return;
					case EnumSymbol(e, params):
						if (defaultChildren == null) {
							errorTagUnexpected(tagData);
							return;
						}
						defaultChildren.push(unitData);
						return;
					default:
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

	private static function createValueExprForFieldTag(tagData:IMXHXTagData, childUnits:Array<IMXHXUnitData>, field:ClassField, fieldType:Type,
			outerDocumentTypePath:TypePath, generatedFields:Array<Field>):Expr {
		var isArray = false;
		var isString = false;
		var fieldName:String = tagData.shortName;
		if (field != null) {
			fieldName = field.name;
			fieldType = field.type;
		}

		var baseType:BaseType = null;
		var enumType:EnumType = null;
		var abstractType:AbstractType = null;
		var resolvedTypeParams:Array<Type> = null;
		var currentType = fieldType;
		if (currentType != null) {
			while (true) {
				switch (currentType) {
					case TInst(t, params):
						baseType = t.get();
						resolvedTypeParams = params;
						break;
					case TAbstract(t, params):
						abstractType = t.get();
						if (abstractType.name == TYPE_NULL) {
							abstractType = null;
							currentType = params[0];
						} else {
							baseType = abstractType;
							resolvedTypeParams = params;
							break;
						}
					case TEnum(t, params):
						enumType = t.get();
						baseType = enumType;
						resolvedTypeParams = params;
						break;
					case TLazy(f):
						currentType = f();
					default:
						break;
				}
			}
			if (baseType != null) {
				isArray = baseType.pack.length == 0 && baseType.name == TYPE_ARRAY;
				isString = baseType.pack.length == 0 && baseType.name == TYPE_STRING;
			}
		}

		var firstChildIsArrayTag = false;
		var valueExprs:Array<Expr> = [];
		var firstChild = (childUnits != null) ? childUnits.shift() : tagData.getFirstChildUnit();
		var current = firstChild;
		while (current != null) {
			if (current == firstChild && (current is IMXHXTextData) && current.getNextSiblingUnit() == null) {
				var textData = cast(current, IMXHXTextData);
				if (textData.textType == Text && isLanguageTypeAssignableFromText(baseType)) {
					return handleTextContentAsExpr(textData.content, baseType, enumType, 0, textData);
				}
			}
			if (!isArray && valueExprs.length > 0) {
				// when the type is not array, multiple children are not allowed
				var isWhitespace = (current is IMXHXTextData) && cast(current, IMXHXTextData).textType == Whitespace;
				if (!isWhitespace) {
					errorUnexpected(current);
					return null;
				}
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
			current = (childUnits != null) ? childUnits.shift() : current.getNextSiblingUnit();
		}
		if (valueExprs.length == 0 && !isArray) {
			if (isString) {
				return macro "";
			}
			reportError('Value for field \'${fieldName}\' must not be empty', sourceLocationToContextPosition(tagData));
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
				switch (resolvedTypeParams[0]) {
					case null:
						// if null, the type was explicit, but could not be resolved
						reportError('Resolved field \'${fieldName}\' to type \'${baseType.name}\', but type parameter is missing',
							sourceLocationToContextPosition(tagData));
					case TInst(t, params):
						var classType = t.get();
						var isTypeParameter = false;
						switch (classType.kind) {
							case KTypeParameter(constraints):
								isTypeParameter = true;
							default:
						}
						if (isTypeParameter) {
							// try to infer the correct type from
							// the items in the array
							var inferredType = inferTypeFromChildrenOfTag(tagData);
							if (inferredType != null) {
								paramType = TypeTools.toComplexType(inferredType);
							}
						} else {
							paramType = TypeTools.toComplexType(resolvedTypeParams[0]);
						}
					default:
						paramType = TypeTools.toComplexType(resolvedTypeParams[0]);
				}
				if (paramType == null) {
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
		return valueExprs[0];
	}

	private static function createValueExprForUnitData(unitData:IMXHXUnitData, assignedToType:Type, outerDocumentTypePath:TypePath,
			generatedFields:Array<Field>):Expr {
		if ((unitData is IMXHXTagData)) {
			var tagData:IMXHXTagData = cast unitData;
			if (isComponentTag(tagData)) {
				return handleComponentTag(tagData, assignedToType, outerDocumentTypePath, generatedFields);
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
				return createValueExprForType(assignedToType, textData.content, fromCdata, unitData);
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

	private static function isLanguageTypeAssignableFromText(t:BaseType):Bool {
		return t != null && t.pack.length == 0 && LANGUAGE_TYPES_ASSIGNABLE_BY_TEXT.indexOf(t.name) != -1;
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
			if (allowId && attrData.name == PROPERTY_ID) {
				continue;
			}
			reportError('Unknown field \'${attrData.name}\'', sourceLocationToContextPosition(attrData));
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

	private static function createValueExprForType(type:Type, value:String, fromCdata:Bool, location:IMXHXSourceLocation):Expr {
		var baseType:BaseType = null;
		while (baseType == null) {
			switch (type) {
				case TInst(t, params):
					baseType = t.get();
					break;
				case TAbstract(t, params):
					var abstractType = t.get();
					if (abstractType.name == TYPE_NULL) {
						type = params[0];
					} else {
						if (abstractType.meta.has(META_ENUM)) {
							return macro $i{value};
						} else {
							baseType = abstractType;
						}
					}
				case TEnum(t, params):
					var enumType = t.get();
					baseType = enumType;
					if (enumType.names.indexOf(value) != -1) {
						return macro $i{value};
					}
					reportError('Cannot parse a value of type \'${enumType.name}\' from \'${value}\'', sourceLocationToContextPosition(location));
					break;
				case TLazy(f):
					type = f();
				case TType(t, params):
					type = t.get().type;
				default:
					reportError('Cannot parse a value of type \'${type.getName()}\' from \'${value}\'', sourceLocationToContextPosition(location));
			}
		}
		if ((baseType.pack.length != 0 || baseType.name != TYPE_STRING) && value.length == 0) {
			reportError('Value of type \'${baseType.name}\' cannot be empty', sourceLocationToContextPosition(location));
		}
		return createValueExprForBaseType(baseType, value, fromCdata, location);
	}

	private static function createDefaultValueExprForBaseType(t:BaseType, location:IMXHXSourceLocation):Expr {
		if (t.pack.length == 0) {
			switch (t.name) {
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

	private static function createValueExprForBaseType(t:BaseType, value:String, fromCdata:Bool, location:IMXHXSourceLocation):Expr {
		if (t.pack.length == 0) {
			switch (t.name) {
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
						reportError('Cannot parse a value of type \'${t.name}\' from \'${value}\'', sourceLocationToContextPosition(location));
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
		reportError('Cannot parse a value of type \'${t.name}\' from \'${value}\'', sourceLocationToContextPosition(location));
		return null;
	}

	private static function getDefaultProperty(t:BaseType):String {
		var metaDefaultXmlProperty = META_DEFAULT_XML_PROPERTY;
		if (!t.meta.has(metaDefaultXmlProperty)) {
			metaDefaultXmlProperty = ":" + metaDefaultXmlProperty;
			if (!t.meta.has(metaDefaultXmlProperty)) {
				return null;
			}
		}
		var defaultPropertyMeta = t.meta.extract(metaDefaultXmlProperty)[0];
		if (defaultPropertyMeta.params.length != 1) {
			reportError('The @${metaDefaultXmlProperty} meta must have one property name', defaultPropertyMeta.pos);
		}
		var param = defaultPropertyMeta.params[0];
		var propertyName:String = null;
		switch (param.expr) {
			case EConst(c):
				switch (c) {
					case CString(s, kind):
						propertyName = s;
					default:
				}
			default:
		}
		if (propertyName == null) {
			reportError('The @${META_DEFAULT_XML_PROPERTY} meta param must be a string', param.pos);
			return null;
		}
		return propertyName;
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

	private static function inferTypeFromChildrenOfTag(tagData:IMXHXTagData):Type {
		var currentChild = tagData.getFirstChildTag(true);
		var resolvedChildType:Type = null;
		while (currentChild != null) {
			var currentChildType = mxhxResolver.resolveTagAsMacroType(currentChild);
			resolvedChildType = MXHXMacroTools.getUnifiedType(currentChildType, resolvedChildType);
			if (resolvedChildType == null) {
				reportError('Arrays of mixed types are only allowed if the type is forced to Array<Dynamic>', sourceLocationToContextPosition(currentChild));
			}
			currentChild = currentChild.getNextSiblingTag(true);
		}
		return resolvedChildType;
	}

	private static function needsOverride(funcName:String, theClass:ClassType):Bool {
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

	private static function fieldExists(fieldName:String, theClass:ClassType):Bool {
		var currentClass = theClass;
		while (currentClass != null) {
			var field = Lambda.find(currentClass.fields.get(), f -> f.name == fieldName);
			if (field != null) {
				switch (field.kind) {
					case FVar(read, write):
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

	private static function errorTagNotSupported(tagData:IMXHXTagData):Void {
		reportError('Tag \'<${tagData.name}>\' is not supported by the \'${languageUri}\' namespace', sourceLocationToContextPosition(tagData));
	}

	private static function errorStatesNotSupported(sourceLocation:IMXHXSourceLocation):Void {
		reportError('States are not supported by the \'${languageUri}\' namespace', sourceLocationToContextPosition(sourceLocation));
	}

	private static function errorEventsNotSupported(sourceLocation:IMXHXSourceLocation):Void {
		reportError('Events are not supported by the \'${languageUri}\' namespace', sourceLocationToContextPosition(sourceLocation));
	}

	private static function errorEventsNotConfigured(sourceLocation:IMXHXSourceLocation):Void {
		reportError('Adding event listeners has not been configured', sourceLocationToContextPosition(sourceLocation));
	}

	private static function errorBindingNotSupported(sourceLocation:IMXHXSourceLocation):Void {
		reportError('Binding is not supported by the \'${languageUri}\' namespace', sourceLocationToContextPosition(sourceLocation));
	}

	private static function errorTagUnexpected(tagData:IMXHXTagData):Void {
		reportError('Tag \'<${tagData.name}>\' is unexpected', sourceLocationToContextPosition(tagData));
	}

	private static function errorTextUnexpected(textData:IMXHXTextData):Void {
		reportError('The \'${textData.content}\' value is unexpected', sourceLocationToContextPosition(textData));
	}

	private static function errorAttributeUnexpected(attrData:IMXHXTagAttributeData):Void {
		reportError('Attribute \'${attrData.name}\' is unexpected', sourceLocationToContextPosition(attrData));
	}

	private static function errorDuplicateField(fieldName:String, tagData:IMXHXTagData, sourceLocation:IMXHXSourceLocation):Void {
		reportError('Field \'${fieldName}\' is already specified for element \'${tagData.name}\'', sourceLocationToContextPosition(sourceLocation));
	}

	private static function reportError(message:String, position:Position):Void {
		#if (haxe_ver >= 4.3)
		Context.reportError(message, position);
		#else
		Context.error(message, position);
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
		reportError('MXHX data is unexpected', sourceLocationToContextPosition(unitData));
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

	private static function getAttributeValueSourceLocation(attrData:IMXHXTagAttributeData):IMXHXSourceLocation {
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
