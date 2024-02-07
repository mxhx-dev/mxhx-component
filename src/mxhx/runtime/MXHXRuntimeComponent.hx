package mxhx.runtime;

import mxhx.parser.MXHXParser;
import mxhx.resolver.IMXHXAbstractSymbol;
import mxhx.resolver.IMXHXClassSymbol;
import mxhx.resolver.IMXHXEnumFieldSymbol;
import mxhx.resolver.IMXHXEnumSymbol;
import mxhx.resolver.IMXHXEventSymbol;
import mxhx.resolver.IMXHXFieldSymbol;
import mxhx.resolver.IMXHXResolver;
import mxhx.resolver.IMXHXTypeSymbol;
import mxhx.resolver.MXHXSymbolTools;
import mxhx.resolver.rtti.MXHXRttiResolver;

class MXHXRuntimeComponent {
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
	private static final ATTRIBUTE_FORMAT = "format";
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
	private static final LITERAL_NULL = "null";
	private static final LITERAL_ZERO = "0";
	private static final LITERAL_EMPTY_EREG = "~//";
	private static final LITERAL_EMPTY_STRING = '""';
	private static final LITERAL_EMPTY_STRUCT = "{}";
	private static final CONSTANT_MATH_NAN = "Math.NaN";
	private static final CONSTANT_MATH_POSITIVE_INFINITY = "Math.POSITIVE_INFINITY";
	private static final CONSTANT_MATH_NEGATIVE_INFINITY = "Math.NEGATIVE_INFINITY";
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
	private static var languageUri:String = null;
	private static var mxhxResolver:IMXHXResolver;

	/**
		Instantiates a component from markup.
	**/
	public static function withMarkup(mxhxText:String, ?idMap:Map<String, Any>):Any {
		return createFromString(mxhxText, idMap);
	}

	private static function createFromString(mxhxText:String, idMap:Map<String, Any>):Any {
		var mxhxParser = new MXHXParser(mxhxText, "runtime.mxhx");
		var mxhxData = mxhxParser.parse();
		if (mxhxData.problems.length > 0) {
			for (problem in mxhxData.problems) {
				reportError(problem.message, problem);
			}
			return null;
		}
		return createFromTagData(mxhxData.rootTag, idMap);
	}

	private static function createFromTagData(rootTag:IMXHXTagData, idMap:Map<String, Any>):Any {
		if (mxhxResolver == null) {
			createResolver();
		}
		var implementsAttrData = rootTag.getAttributeData(ATTRIBUTE_IMPLEMENTS);
		if (implementsAttrData != null) {
			reportError('The \'${ATTRIBUTE_IMPLEMENTS}\' attribute is not supported', implementsAttrData);
		}
		if (idMap == null) {
			idMap = [];
		}
		return handleRootTag(rootTag, idMap);
	}

	private static function createResolver():Void {
		mxhxResolver = new MXHXRttiResolver();
	}

	private static function handleRootTag(tagData:IMXHXTagData, idMap:Map<String, Any>):Any {
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
								reportError('Namespace \'$uri\' is not supported at runtime. Use namespace \'$LANGUAGE_URI_BASIC_2024\' instead.', attrData);
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

		var instance:Any = createInstance(resolvedType, tagData);
		var attributeAndChildNames:Map<String, Bool> = [];
		handleAttributesOfInstanceTag(tagData, resolvedType, instance, attributeAndChildNames);
		handleChildUnitsOfInstanceTag(tagData, resolvedType, instance, idMap, attributeAndChildNames);
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			reportError('id attribute is not allowed on the root tag of a component.', idAttr);
		}
		return instance;
	}

	private static function handleAttributesOfInstanceTag(tagData:IMXHXTagData, parentSymbol:IMXHXTypeSymbol, target:Any,
			attributeAndChildNames:Map<String, Bool>):Void {
		for (attribute in tagData.attributeData) {
			handleAttributeOfInstanceTag(attribute, parentSymbol, target, attributeAndChildNames);
		}
	}

	private static function handleAttributeOfInstanceTag(attrData:IMXHXTagAttributeData, parentSymbol:IMXHXTypeSymbol, target:Any,
			attributeAndChildNames:Map<String, Bool>):Void {
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
				var value = createValueForDynamic(attrData.rawValue);
				Reflect.setProperty(target, attrData.shortName, value);
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
			errorEventsNotSupported(attrData);
		} else if ((resolved is IMXHXFieldSymbol)) {
			var fieldSymbol:IMXHXFieldSymbol = cast resolved;
			var fieldName = fieldSymbol.name;
			var value = handleTextContentAsValue(attrData.rawValue, fieldSymbol.type, attrData.valueStart, getAttributeValueSourceLocation(attrData));
			Reflect.setProperty(target, fieldName, value);
		} else {
			errorAttributeUnexpected(attrData);
		}
	}

	private static function handleChildUnitsOfInstanceTag(tagData:IMXHXTagData, parentSymbol:IMXHXTypeSymbol, target:Any, idMap:Map<String, Any>,
			attributeAndChildNames:Map<String, Bool>):Any {
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
			return createInitCallback(tagData, parentSymbol, idMap)();
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
			handleChildUnitsOfInstanceTagWithDefaultProperty(tagData, parentSymbol, defaultProperty, target, idMap, attributeAndChildNames);
			return null;
		}

		var arrayChildren:Array<IMXHXUnitData> = isArray ? [] : null;
		var current = tagData.getFirstChildUnit();
		while (current != null) {
			handleChildUnitOfInstanceTag(current, parentSymbol, target, idMap, attributeAndChildNames, arrayChildren);
			current = current.getNextSiblingUnit();
		}
		if (!isArray) {
			return null;
		}

		var arrayTarget:Array<Any> = cast target;
		var arrayItems:Array<Any> = [];
		for (child in arrayChildren) {
			handleChildUnitOfArrayOrDeclarationsTag(child, idMap, arrayItems);
		}
		for (i in 0...arrayItems.length) {
			var arrayItem = arrayItems[i];
			arrayTarget[i] = arrayItem;
		}
		return null;
	}

	private static function handleChildUnitsOfInstanceTagWithDefaultProperty(tagData:IMXHXTagData, parentSymbol:IMXHXTypeSymbol, defaultProperty:String,
			target:Any, idMap:Map<String, Any>, attributeAndChildNames:Map<String, Bool>):Void {
		var defaultChildren:Array<IMXHXUnitData> = [];
		var current = tagData.getFirstChildUnit();
		while (current != null) {
			handleChildUnitOfInstanceTag(current, parentSymbol, target, idMap, attributeAndChildNames, defaultChildren);
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

		var value = createValueForFieldTag(tagData, defaultChildren, resolvedField, null, idMap);
		Reflect.setProperty(target, fieldName, value);
	}

	private static function handleChildUnitOfInstanceTag(unitData:IMXHXUnitData, parentSymbol:IMXHXTypeSymbol, target:Any, idMap:Map<String, Any>,
			attributeAndChildNames:Map<String, Bool>, defaultChildren:Array<IMXHXUnitData>):Void {
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
					handleChildUnitsOfDeclarationsTag(tagData, idMap);
					return;
				}
				if (isLanguageTag(TAG_BINDING, tagData)) {
					errorBindingNotSupported(tagData);
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
					if (attributeAndChildNames.exists(fieldName)) {
						errorDuplicateField(fieldName, tagData.parentTag, tagData);
						return;
					}
					attributeAndChildNames.set(fieldName, true);
					var value = createValueForFieldTag(tagData, null, null, null, idMap);
					Reflect.setProperty(target, fieldName, value);
					return;
				}
				errorTagUnexpected(tagData);
				return;
			} else {
				if ((resolvedTag is IMXHXEventSymbol)) {
					errorEventsNotSupported(tagData);
				} else if ((resolvedTag is IMXHXFieldSymbol)) {
					var fieldSymbol:IMXHXFieldSymbol = cast resolvedTag;
					var fieldName = fieldSymbol.name;
					if (attributeAndChildNames.exists(fieldName)) {
						errorDuplicateField(fieldName, tagData.parentTag, tagData);
						return;
					}
					attributeAndChildNames.set(fieldName, true);
					if (tagData.stateName != null) {
						errorStatesNotSupported(tagData);
						return;
					}
					checkForInvalidAttributes(tagData, false);
					var value = createValueForFieldTag(tagData, null, fieldSymbol, null, idMap);
					Reflect.setProperty(target, fieldName, value);
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

	private static function handleChildUnitsOfDeclarationsTag(tagData:IMXHXTagData, idMap:Map<String, Any>):Void {
		var current = tagData.getFirstChildUnit();
		while (current != null) {
			handleChildUnitOfArrayOrDeclarationsTag(current, idMap);
			current = current.getNextSiblingUnit();
		}
	}

	private static function handleChildUnitOfArrayOrDeclarationsTag(unitData:IMXHXUnitData, idMap:Map<String, Any>, ?initResults:Array<Any>):Void {
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
			reportError("Component tag not implemented", tagData);
			return;
		}
		if (isLanguageTag(TAG_MODEL, tagData)) {
			handleModelTag(tagData, idMap);
			return;
		}
		var resolvedTag = mxhxResolver.resolveTag(tagData);
		if (resolvedTag == null) {
			errorTagUnexpected(tagData);
			return;
		} else {
			if ((resolvedTag is IMXHXClassSymbol)) {
				var classSymbol:IMXHXClassSymbol = cast resolvedTag;
				var initResult = createInitCallback(tagData, classSymbol, idMap)();
				if (initResults != null) {
					initResults.push(initResult);
				}
				return;
			} else if ((resolvedTag is IMXHXAbstractSymbol)) {
				var abstractSymbol:IMXHXAbstractSymbol = cast resolvedTag;
				var initResult = createInitCallback(tagData, abstractSymbol, idMap)();
				if (initResults != null) {
					initResults.push(initResult);
				}
				return;
			} else if ((resolvedTag is IMXHXEnumSymbol)) {
				var enumSymbol:IMXHXEnumSymbol = cast resolvedTag;
				var initResult = createInitCallback(tagData, enumSymbol, idMap)();
				if (initResults != null) {
					initResults.push(initResult);
				}
				return;
			} else {
				errorTagUnexpected(tagData);
				return;
			}
		}
	}

	private static function handleInstanceTag(tagData:IMXHXTagData, assignedToType:IMXHXTypeSymbol, idMap:Map<String, Any>):Any {
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
			return createInitCallback(tagData.parentTag, enumFieldSymbol.parent, idMap)();
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
					return handleXmlTag(tagData, idMap);
				case TYPE_DATE:
					return handleDateTag(tagData, idMap);
				default:
			}
		}
		var instance:Any = null;
		if (!isLanguageTypeAssignableFromText(resolvedType)) {
			instance = createInstance(resolvedType, tagData);
		}
		var attributeAndChildNames:Map<String, Bool> = [];
		handleAttributesOfInstanceTag(tagData, resolvedType, instance, attributeAndChildNames);
		var childUnitsResult = handleChildUnitsOfInstanceTag(tagData, resolvedType, instance, idMap, attributeAndChildNames);

		var id:String = null;
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			id = idAttr.rawValue;
		}
		if (id != null) {
			addFieldForID(id, instance, idMap);
		} else {
			// field names can't start with a number, so starting a generated
			// id with a number won't conflict with real fields
			id = Std.string(Math.fceil(objectCounter));
			objectCounter++;
		}
		if (resolvedEnum != null || isLanguageTypeAssignableFromText(resolvedType)) {
			// no need for a function. return the simple expression.
			// handleChildUnitsOfInstanceTag() checks for too many children
			// so no need to worry about that here
			return childUnitsResult;
		} else {
			return instance;
		}
	}

	private static function handleInstanceTagAssignableFromText(tagData:IMXHXTagData, typeSymbol:IMXHXTypeSymbol, idMap:Map<String, Any>):Any {
		var value:Any = null;
		var isStringWithSource = false;
		if (typeSymbol != null && typeSymbol.pack.length == 0 && typeSymbol.name == TYPE_STRING) {
			var sourceAttr = tagData.getAttributeData(ATTRIBUTE_SOURCE);
			if (sourceAttr != null) {
				reportError("String source attribute is not supported", sourceAttr);
			}
		}
		var child = tagData.getFirstChildUnit();
		var bindingTextData:IMXHXTextData = null;
		if (value == null) {
			if (child != null && (child is IMXHXTextData) && child.getNextSiblingUnit() == null) {
				var textData = cast(child, IMXHXTextData);
				if (textData.textType == Text && isLanguageTypeAssignableFromText(typeSymbol)) {
					value = handleTextContentAsValue(textData.content, typeSymbol, 0, textData);
					bindingTextData = textData;
				}
			}
		}
		if (value == null) {
			var pendingText:String = null;
			var pendingTextIncludesCData = false;
			do {
				if (child == null) {
					if (value != null) {
						// this shouldn't happen, but just to be safe
						errorTagUnexpected(tagData);
					} else {
						// no text found, so use default value instead
						value = createDefaultValueForTypeSymbol(typeSymbol, tagData);
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
					value = createValueForTypeSymbol(typeSymbol, pendingText, pendingTextIncludesCData, tagData);
				}
			} while (child != null || value == null);
		}
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			var id = idAttr.rawValue;
			addFieldForID(id, value, idMap);
			if (bindingTextData != null && textContentContainsBinding(bindingTextData.content)) {
				errorBindingNotSupported(tagData);
			}
		}
		for (attribute in tagData.attributeData) {
			if (attribute.name == ATTRIBUTE_SOURCE && isStringWithSource) {
				continue;
			}
			if (attribute.name != ATTRIBUTE_ID) {
				errorAttributeUnexpected(attribute);
			}
		}
		return value;
	}

	private static function handleDateTag(tagData:IMXHXTagData, idMap:Map<String, Any>):Date {
		var intType = mxhxResolver.resolveQname(TYPE_INT);
		var hasCustom = false;
		var fullYear:Null<Int> = null;
		var month:Null<Int> = null;
		var date:Null<Int> = null;
		var hours:Null<Int> = null;
		var minutes:Null<Int> = null;
		var seconds:Null<Int> = null;
		for (attrData in tagData.attributeData) {
			switch (attrData.name) {
				case FIELD_FULL_YEAR:
					hasCustom = true;
					if (fullYear != null) {
						errorDuplicateField(FIELD_FULL_YEAR, tagData, getAttributeNameSourceLocation(attrData));
					}
					fullYear = createValueForTypeSymbol(intType, attrData.rawValue, false, attrData);
				case FIELD_MONTH:
					hasCustom = true;
					if (month != null) {
						errorDuplicateField(FIELD_MONTH, tagData, getAttributeNameSourceLocation(attrData));
					}
					month = createValueForTypeSymbol(intType, attrData.rawValue, false, attrData);
				case FIELD_DATE:
					hasCustom = true;
					if (date != null) {
						errorDuplicateField(FIELD_DATE, tagData, getAttributeNameSourceLocation(attrData));
					}
					date = createValueForTypeSymbol(intType, attrData.rawValue, false, attrData);
				case FIELD_HOURS:
					hasCustom = true;
					if (hours != null) {
						errorDuplicateField(FIELD_HOURS, tagData, getAttributeNameSourceLocation(attrData));
					}
					hours = createValueForTypeSymbol(intType, attrData.rawValue, false, attrData);
				case FIELD_MINUTES:
					hasCustom = true;
					if (minutes != null) {
						errorDuplicateField(FIELD_MINUTES, tagData, getAttributeNameSourceLocation(attrData));
					}
					minutes = createValueForTypeSymbol(intType, attrData.rawValue, false, attrData);
				case FIELD_SECONDS:
					hasCustom = true;
					if (seconds != null) {
						errorDuplicateField(FIELD_SECONDS, tagData, getAttributeNameSourceLocation(attrData));
					}
					seconds = createValueForTypeSymbol(intType, attrData.rawValue, false, attrData);
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
						fullYear = createValueForFieldTag(childTag, null, null, intType, idMap);
					case FIELD_MONTH:
						hasCustom = true;
						if (month != null) {
							errorDuplicateField(FIELD_MONTH, tagData, childTag);
						}
						month = createValueForFieldTag(childTag, null, null, intType, idMap);
					case FIELD_DATE:
						hasCustom = true;
						if (date != null) {
							errorDuplicateField(FIELD_DATE, tagData, childTag);
						}
						date = createValueForFieldTag(childTag, null, null, intType, idMap);
					case FIELD_HOURS:
						hasCustom = true;
						if (hours != null) {
							errorDuplicateField(FIELD_HOURS, tagData, childTag);
						}
						hours = createValueForFieldTag(childTag, null, null, intType, idMap);
					case FIELD_MINUTES:
						hasCustom = true;
						if (minutes != null) {
							errorDuplicateField(FIELD_MINUTES, tagData, childTag);
						}
						minutes = createValueForFieldTag(childTag, null, null, intType, idMap);
					case FIELD_SECONDS:
						hasCustom = true;
						if (seconds != null) {
							errorDuplicateField(FIELD_SECONDS, tagData, childTag);
						}
						seconds = createValueForFieldTag(childTag, null, null, intType, idMap);
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

		var value:Any = null;
		if (!hasCustom) {
			value = Date.now();
		} else {
			var now = Date.now();
			if (fullYear == null) {
				fullYear = now.getFullYear();
			}
			if (month == null) {
				month = now.getMonth();
			}
			if (date == null) {
				date = now.getDate();
			}
			if (hours == null) {
				hours = now.getHours();
			}
			if (minutes == null) {
				minutes = now.getMinutes();
			}
			if (seconds == null) {
				seconds = now.getSeconds();
			}
			value = new Date(fullYear, month, date, hours, minutes, seconds);
		}

		var id:String = null;
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			id = idAttr.rawValue;
		}
		if (id != null) {
			addFieldForID(id, value, idMap);
		}

		return value;
	}

	private static function handleXmlTag(tagData:IMXHXTagData, idMap:Map<String, Any>):Xml {
		var formatAttr = tagData.getAttributeData(ATTRIBUTE_FORMAT);
		if (formatAttr != null) {
			errorAttributeNotSupported(formatAttr);
			return null;
		}
		var sourceAttr = tagData.getAttributeData(ATTRIBUTE_SOURCE);
		if (sourceAttr != null) {
			reportError("Xml source attribute is not supported", sourceAttr);
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
					default: null;
				}
				if (textChild != null) {
					parentStack[parentStack.length - 1].addChild(textChild);
				}
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
		if (xmlDoc.firstChild() == null) {
			xmlDoc.addChild(Xml.createPCData(""));
		}

		for (attribute in tagData.attributeData) {
			if (attribute.name != ATTRIBUTE_ID && attribute.name != ATTRIBUTE_FORMAT && attribute.name != ATTRIBUTE_SOURCE) {
				errorAttributeUnexpected(attribute);
			}
		}

		var id:String = null;
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			id = idAttr.rawValue;
		}
		if (id != null) {
			addFieldForID(id, xmlDoc, idMap);
		}

		return xmlDoc;
	}

	private static function handleModelTag(tagData:IMXHXTagData, idMap:Map<String, Any>):Any {
		var current:IMXHXUnitData = null;
		var sourceAttr = tagData.getAttributeData(ATTRIBUTE_SOURCE);
		if (sourceAttr != null) {
			reportError("Model source attribute is not supported", sourceAttr);
		}
		if (current == null) {
			current = tagData.getFirstChildUnit();
		}
		var model:ModelObject = null;
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
							reportWarning('Ignoring attribute \'${attrData.name}\' on root tag', attrData);
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
					if (rootTag == null) {
						reportError("Model must not contain only scalar content", tagData);
						return null;
					}
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

		var value:Any = null;
		if (model != null) {
			value = createModelObject(model, tagData);
		} else {
			value = {};
		}

		for (attribute in tagData.attributeData) {
			if (attribute.name != ATTRIBUTE_ID && attribute.name != ATTRIBUTE_SOURCE) {
				errorAttributeUnexpected(attribute);
			}
		}

		var id:String = null;
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			id = idAttr.rawValue;
		}
		if (id != null) {
			addFieldForID(id, value, idMap);
		}

		return value;
	}

	private static function createModelObject(model:ModelObject, sourceLocation:IMXHXSourceLocation):Any {
		if (model.value != null) {
			return createValueForDynamic(model.value);
		}
		if (model.text.length > 0) {
			var hasFields = model.fields.iterator().hasNext() && model.strongFields;
			var hasMultipleTextTypes = false;
			var textType:MXHXTextType = null;
			for (textData in model.text) {
				if (textType == null) {
					textType = textData.textType;
				} else if (textType != textData.textType) {
					hasMultipleTextTypes = true;
					break;
				}
			}
			var pendingText:String = "";
			for (textData in model.text) {
				if (hasFields || hasMultipleTextTypes) {
					reportWarning('Ignoring text \'${textData.content}\' because other XML content exists', textData);
					continue;
				}
				for (fieldName => models in model.fields) {
					for (current in models) {
						reportWarning('Ignoring attribute \'${fieldName}\' because other XML content exists', current.location);
					}
				}
				if (textContentContainsBinding(textData.content)) {
					reportError('Binding is not supported here', textData);
				}
				pendingText += textData.content;
			}
			return createValueForDynamic(pendingText);
		}
		var modelValue:Any = {};
		for (fieldName => subModels in model.fields) {
			if (subModels.length == 1) {
				var subModelValue = createModelObject(subModels[0], sourceLocation);
				Reflect.setField(modelValue, fieldName, subModelValue);
			} else {
				var array:Array<Any> = [];
				for (i in 0...subModels.length) {
					var subModel = subModels[i];
					var subModelValue = createModelObject(subModel, sourceLocation);
					array[i] = subModelValue;
				}
				Reflect.setField(modelValue, fieldName, array);
			}
		}
		return modelValue;
	}

	private static function handleInstanceTagEnumValue(tagData:IMXHXTagData, typeSymbol:IMXHXTypeSymbol, idMap:Map<String, Any>):Any {
		var enumValue = createEnumValue(tagData, idMap);
		var idAttr = tagData.getAttributeData(ATTRIBUTE_ID);
		if (idAttr != null) {
			var id = idAttr.rawValue;
			addFieldForID(id, enumValue, idMap);
		}
		return enumValue;
	}

	private static function createEnumValue(tagData:IMXHXTagData, idMap:Map<String, Any>):Any {
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
				var initArgs:Array<Any> = [];
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
						var value = createValueForTypeSymbol(arg.type, attrData.rawValue, false, attrData);
						initArgs.push(value);
					} else if (tagLookup.exists(argName)) {
						var grandChildTag = tagLookup.get(argName);
						tagLookup.remove(argName);
						var value = createValueForFieldTag(grandChildTag, null, null, arg.type, idMap);
						initArgs.push(value);
					} else if (arg.optional) {
						initArgs.push(null);
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
					var resolvedEnum = Type.resolveEnum(enumSymbol.pack.join(".") + "." + enumSymbol.name);
					return resolvedEnum.createByName(fieldName, initArgs);
				} else {
					var resolvedEnum = Type.resolveEnum(enumSymbol.name);
					return resolvedEnum.createByName(fieldName, initArgs);
				}
			} else {
				if (enumSymbol.pack.length > 0) {
					var resolvedEnum = Type.resolveEnum(enumSymbol.pack.join(".") + "." + enumSymbol.name);
					return resolvedEnum.createByName(fieldName);
				} else {
					var resolvedEnum = Type.resolveEnum(enumSymbol.name);
					return resolvedEnum.createByName(fieldName);
				}
			}
		} else {
			errorUnexpected(childTag);
		}
		return null;
	}

	private static function addFieldForID(id:String, instance:Any, idMap:Map<String, Any>):Void {
		idMap.set(id, instance);
	}

	private static function createInitCallback(tagData:IMXHXTagData, typeSymbol:IMXHXTypeSymbol, idMap:Map<String, Any>):() -> Any {
		var initCallback:() -> Any = null;
		if ((typeSymbol is IMXHXEnumSymbol)) {
			if (!tagContainsOnlyText(tagData)) {
				initCallback = () -> handleInstanceTagEnumValue(tagData, typeSymbol, idMap);
			} else {
				initCallback = () -> handleInstanceTagAssignableFromText(tagData, typeSymbol, idMap);
			}
		} else if (isLanguageTypeAssignableFromText(typeSymbol)) {
			initCallback = () -> handleInstanceTagAssignableFromText(tagData, typeSymbol, idMap);
		} else {
			initCallback = () -> handleInstanceTag(tagData, null, idMap);
		}
		return initCallback;
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

	private static function handleTextContentAsValue(text:String, fieldType:IMXHXTypeSymbol, textStartOffset:Int, sourceLocation:IMXHXSourceLocation):Any {
		var expr:String = null;
		var startIndex = 0;
		var pendingText:String = "";
		do {
			var bindingStartIndex = text.indexOf("{", startIndex);
			if (bindingStartIndex == -1) {
				if (expr == null && pendingText.length == 0) {
					return createValueForTypeSymbol(fieldType, text, false, sourceLocation);
				}
				pendingText += text.substring(startIndex);
				if (pendingText.length > 0) {
					if (expr == null) {
						expr = pendingText;
					} else {
						expr = expr + pendingText;
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
					errorBindingNotSupported(new CustomMXHXSourceLocation(sourceLocation.start + bindingStartIndex,
						sourceLocation.start + bindingEndIndex + 1, sourceLocation.source));
					return null;
				}
			}
		} while (true);
		return expr;
	}

	private static function checkForInvalidAttributes(tagData:IMXHXTagData, allowId:Bool):Void {
		for (attrData in tagData.attributeData) {
			if (allowId && attrData.name == ATTRIBUTE_ID) {
				continue;
			}
			reportError('Unknown field \'${attrData.name}\'', getAttributeNameSourceLocation(attrData));
		}
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

	private static function createInstance(typeSymbol:IMXHXTypeSymbol, sourceLocation:IMXHXSourceLocation):Any {
		var qname = typeSymbol.name;
		if (typeSymbol.pack != null && typeSymbol.pack.length > 0) {
			qname = typeSymbol.pack.join(".") + "." + typeSymbol.name;
		}
		if (qname == TYPE_DYNAMIC || qname == TYPE_ANY) {
			return {};
		}
		var resolvedClass = Type.resolveClass(qname);
		if (resolvedClass == null) {
			reportError('Type not found: \'${qname}\'', sourceLocation);
		}
		return Type.createInstance(resolvedClass, []);
	}

	private static function createValueForFieldTag(tagData:IMXHXTagData, childUnits:Array<IMXHXUnitData>, field:IMXHXFieldSymbol, fieldType:IMXHXTypeSymbol,
			idMap:Map<String, Any>):Any {
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
		var values:Array<Any> = [];
		var pendingText:String = null;
		var pendingTextIncludesCData = false;
		var firstChild = (childUnits != null) ? childUnits.shift() : tagData.getFirstChildUnit();
		var current = firstChild;
		while (current != null) {
			var next = (childUnits != null) ? childUnits.shift() : current.getNextSiblingUnit();
			if ((current is IMXHXTextData)) {
				var textData = cast(current, IMXHXTextData);
				if (textData == firstChild && next == null && textData.textType == Text && isLanguageTypeAssignableFromText(fieldType)) {
					return handleTextContentAsValue(textData.content, fieldType, 0, textData);
				}
				if (!canIgnoreTextData(textData)) {
					if (values.length > 0) {
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
			if (!isArray && values.length > 0) {
				// when the type is not array, multiple children are not allowed
				errorUnexpected(current);
				current = next;
				continue;
			}
			var value = createValueForUnitData(current, fieldType, idMap);
			if (values.length == 0 && (current is IMXHXTagData)) {
				var tagData:IMXHXTagData = cast current;
				if (tagData.shortName == TYPE_ARRAY && tagData.uri == languageUri) {
					firstChildIsArrayTag = true;
				}
			}
			values.push(value);
			current = next;
		}
		if (pendingText != null) {
			var value:Any = null;
			if (fieldType != null) {
				value = createValueForTypeSymbol(fieldType, pendingText, pendingTextIncludesCData, tagData);
			} else {
				value = createValueForDynamic(pendingText);
			}
			values.push(value);
		}
		if (values.length == 0 && !isArray) {
			if (isString) {
				return "";
			}
			reportError('Value for field \'${fieldName}\' must not be empty', tagData);
			return null;
		}

		if (isArray) {
			if (values.length == 1 && firstChildIsArrayTag) {
				return values[0];
			}

			var localVarName = "array_" + fieldName;
			if (fieldType != null) {
				var paramType:IMXHXTypeSymbol = null;
				if (fieldType.params.length == 0) {
					// if missing, the type was explicit, but could not be resolved
					reportError('Resolved field \'${fieldName}\' to type \'${fieldType.qname}\', but type parameter is missing', tagData);
				} else {
					paramType = fieldType.params[0];
				}

				var attrData = tagData.getAttributeData(ATTRIBUTE_TYPE);
				if (paramType == null && attrData != null) {
					reportError('The type parameter \'${attrData.rawValue}\' for tag \'<${tagData.name}>\' cannot be resolved',
						getAttributeValueSourceLocation(attrData));
				}

				if (paramType == null) {
					// next, try to infer the correct type from the array items
					paramType = inferTypeFromChildrenOfTag(tagData);
				}
				if (paramType == null) {
					// finally, default to null
					paramType = mxhxResolver.resolveQname("Dynamic");
				}
			}
			return values;
		}
		// not an array
		if (values.length > 1) {
			// this shouldn't happen, but just to be safe
			reportError('Too many expressions for field \'${fieldName}\'', tagData);
		}
		return values[0];
	}

	private static function createValueForUnitData(unitData:IMXHXUnitData, assignedToType:IMXHXTypeSymbol, idMap:Map<String, Any>):Any {
		if ((unitData is IMXHXTagData)) {
			var tagData:IMXHXTagData = cast unitData;
			if (isComponentTag(tagData)) {
				reportError("Component tag not implemented", tagData);
			}
			if (isLanguageTag(TAG_MODEL, tagData)) {
				handleModelTag(tagData, idMap);
			}
			return handleInstanceTag(tagData, assignedToType, idMap);
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
				return createValueForTypeSymbol(assignedToType, textData.content, fromCdata, unitData);
			}
			return createValueForDynamic(textData.content);
		} else if ((unitData is IMXHXInstructionData)) {
			// safe to ignore
			return null;
		} else {
			errorUnexpected(unitData);
			return null;
		}
	}

	private static function createValueForTypeSymbol(typeSymbol:IMXHXTypeSymbol, value:String, fromCdata:Bool, location:IMXHXSourceLocation):Any {
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
					var enumQname = enumSymbol.pack.join(".") + "." + enumSymbol.name;
					var resolvedEnum = Type.resolveEnum(enumQname);
					return Type.createEnum(resolvedEnum, trimmedValue);
				} else {
					var resolvedEnum = Type.resolveEnum(enumSymbol.name);
					return Type.createEnum(resolvedEnum, trimmedValue);
				}
			}
		}
		if (typeSymbol == null) {
			reportError('Fatal: Type symbol for value \'${value}\' not found', location);
		}
		// when parsing text, string may be empty, but not other types
		if (typeSymbol.qname != TYPE_STRING && value.length == 0) {
			reportError('Value of type \'${typeSymbol.qname}\' cannot be empty', location);
		}
		if (typeSymbol.pack.length == 1 && typeSymbol.pack[0] == "haxe") {
			switch (typeSymbol.name) {
				case TYPE_FUNCTION:
					reportError("Function tag not supported", location);
				default:
			}
		} else if (typeSymbol.pack.length == 0) {
			switch (typeSymbol.name) {
				case TYPE_BOOL:
					value = StringTools.trim(value);
					if (value == VALUE_TRUE || value == VALUE_FALSE) {
						return value == VALUE_TRUE;
					}
				case TYPE_CLASS:
					value = StringTools.trim(value);
					var resolvedClass = Type.resolveClass(value);
					if (resolvedClass == null) {
						reportError('Type not found \'${value}\'', location);
					}
					return resolvedClass;
				case TYPE_EREG:
					value = StringTools.trim(value);
					if (value.length == 0) {
						return ~//;
					}
					// if not empty, must start with ~/ and have final / before flags
					if (!~/^~\/.*?\/[a-z]*$/.match(value)) {
						reportError('Cannot parse a value of type \'${typeSymbol.qname}\' from \'${value}\'', location);
						return null;
					}
					var endSlashIndex = value.lastIndexOf("/");
					var expression = value.substring(2, endSlashIndex);
					var flags = value.substr(endSlashIndex + 1);
					return new EReg(expression, flags);
				case TYPE_FLOAT:
					value = StringTools.trim(value);
					if (value == VALUE_NAN) {
						return Math.NaN;
					} else if (value == VALUE_INFINITY) {
						return Math.POSITIVE_INFINITY;
					} else if (value == VALUE_NEGATIVE_INFINITY) {
						return Math.NEGATIVE_INFINITY;
					}
					if (~/^-?0x[0-9a-fA-F]+$/.match(value)) {
						#if neko
						if (value.charAt(0) == "-") {
							// neko seems to have a bug where it returns 0 when
							// the string starts with the - character
							var intValue = Std.parseInt(value.substr(1));
							if (intValue != null) {
								return -intValue;
							}
						}
						#end
						return Std.parseInt(value);
					}
					if (~/^-?[0-9]+(\.[0-9]+)?(e\-?\d+)?$/.match(value)) {
						return Std.parseFloat(value);
					}
				case TYPE_INT:
					value = StringTools.trim(value);
					#if neko
					if (value.charAt(0) == "-") {
						// neko seems to have a bug where it returns 0 when
						// the string starts with the - character
						var intValue = Std.parseInt(value.substr(1));
						if (intValue != null) {
							return -intValue;
						}
					}
					#end
					var intValue = Std.parseInt(value);
					if (intValue != null) {
						return intValue;
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
						return null;
					} else if (!fromCdata) {
						var trimmed = StringTools.trim(value);
						// if non-cdata consists of only whitespace,
						// return an empty string
						// unless it's in the mx:Declarations tag, then null
						if (trimmed.length == 0) {
							if (inDeclarations) {
								return null;
							} else {
								return trimmed;
							}
						}
					}
					// otherwise, don't modify the original value
					return value;
				case TYPE_UINT:
					value = StringTools.trim(value);
					if (~/^0x[0-9a-fA-F]+$/.match(value)) {
						return Std.parseInt(value);
					}
					if (~/^[0-9]+$/.match(value)) {
						var uintValue = Std.parseInt(value);
						var uintAsFloatValue = Std.parseFloat(value);
						if (uintValue != null && uintValue == uintAsFloatValue) {
							return uintValue;
						}
						return Std.int(uintAsFloatValue);
					}
				default:
			}
		}
		reportError('Cannot parse a value of type \'${typeSymbol.qname}\' from \'${value}\'', location);
		return null;
	}

	private static function createDefaultValueForTypeSymbol(typeSymbol:IMXHXTypeSymbol, location:IMXHXSourceLocation):Any {
		if (typeSymbol.pack.length == 0) {
			switch (typeSymbol.name) {
				case TYPE_BOOL:
					return false;
				case TYPE_EREG:
					return ~//;
				case TYPE_FLOAT:
					return Math.NaN;
				case TYPE_INT:
					return 0;
				case TYPE_STRING:
					if ((location is IMXHXTagData)) {
						var parentTag = cast(location, IMXHXTagData).parentTag;
						if (isLanguageTag(TAG_DECLARATIONS, parentTag)) {
							return null;
						}
					}
					return "";
				case TYPE_UINT:
					return 0;
				default:
					return null;
			}
		}
		return null;
	}

	private static function createValueForDynamic(value:String):Any {
		var trimmed = StringTools.trim(value);
		if (trimmed == VALUE_TRUE || trimmed == VALUE_FALSE) {
			return trimmed == VALUE_TRUE;
		}
		if (~/^-?[0-9]+?$/.match(trimmed)) {
			var intValue = Std.parseInt(trimmed);
			var intAsFloatValue = Std.parseFloat(trimmed);
			if (intValue != null && intValue == intAsFloatValue) {
				return intValue;
			}
			return Std.int(intAsFloatValue);
		}
		if (~/^-?[0-9]+(\.[0-9]+)?(e\-?\d+)?$/.match(trimmed)) {
			return Std.parseFloat(trimmed);
		}
		if (~/^-?0x[0-9a-fA-F]+$/.match(trimmed)) {
			#if neko
			if (value.charAt(0) == "-") {
				// neko seems to have a bug where it returns 0 when
				// the string starts with the - character
				var intValue = Std.parseInt(value.substr(1));
				if (intValue != null) {
					return -intValue;
				}
			}
			#end
			return Std.parseInt(trimmed);
		}
		if (trimmed == VALUE_NAN) {
			return Math.NaN;
		} else if (trimmed == VALUE_INFINITY) {
			return Math.POSITIVE_INFINITY;
		} else if (trimmed == VALUE_NEGATIVE_INFINITY) {
			return Math.NEGATIVE_INFINITY;
		}
		// it can always be parsed as a string
		return value;
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

	private static function getTagTextSourceLocation(tagData:IMXHXTagData):IMXHXSourceLocation {
		var current = tagData.getFirstChildUnit();
		while (current != null) {
			if ((current is IMXHXTextData)) {
				return current;
			}
			current = current.getNextSiblingUnit();
		}
		return tagData;
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

	private static function errorTagWithSourceMustBeEmpty(tagData:IMXHXTagData):Void {
		reportError('Tag \'${tagData.name}\' must be empty if \'source\' attribute is specified', tagData);
	}

	private static function reportError(message:String, sourceLocation:IMXHXSourceLocation):Void {
		throw new MXHXRuntimeComponentException(message, sourceLocation);
	}

	private static function reportWarning(message:String, sourceLocation:IMXHXSourceLocation):Void {
		var line = sourceLocation.line;
		var column = sourceLocation.column;
		trace('Warning: ${message} (${line}, ${column})');
	}
}

class MXHXRuntimeComponentException {
	public var message:String;
	public var location:IMXHXSourceLocation;

	public function new(message:String, location:IMXHXSourceLocation) {
		this.message = message;
		this.location = location;
	}

	public function toString():String {
		return '${message} (${location.line}, ${location.column})';
	}
}

private class CustomMXHXSourceLocation implements IMXHXSourceLocation {
	public var start:Int;
	public var end:Int;
	public var source:String;
	public var line:Int;
	public var column:Int;
	public var endLine:Int;
	public var endColumn:Int;

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
