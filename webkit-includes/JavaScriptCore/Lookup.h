/*
 *  Copyright (C) 1999-2000 Harri Porten (porten@kde.org)
 *  Copyright (C) 2003-2022 Apple Inc. All rights reserved.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

#pragma once

#include "BatchedTransitionOptimizer.h"
#include "CallFrame.h"
#include "CustomGetterSetter.h"
#include "DOMJITGetterSetter.h"
#include "DOMJITSignature.h"
#include "Identifier.h"
#include "IdentifierInlines.h"
#include "ImplementationVisibility.h"
#include "Intrinsic.h"
#include "JSFunction.h"
#include "JSGlobalObject.h"
#include "LazyProperty.h"
#include "PropertySlot.h"
#include "PutPropertySlot.h"
#include "TypeError.h"
#include <wtf/Assertions.h>

namespace JSC {

struct CompactHashIndex {
    const int16_t value;
    const int16_t next;
};

typedef FunctionExecutable* (*BuiltinGenerator)(VM&);
typedef JSValue (*LazyPropertyCallback)(VM&, JSObject*);

// Hash table generated by the create_hash_table script.
struct HashTableValue {

#define FOR_EACH_HASH_ATBLE_VALUE_TYPE(v) \
    v(Accessor) \
    v(BuiltinAccessor) \
    v(BuiltinGenerator) \
    v(Constant) \
    v(DOMJITAttribute) \
    v(DOMJITFunction) \
    v(GetterSetter) \
    v(LazyCellProperty) \
    v(LazyClassStructure) \
    v(LazyProperty) \
    v(Lexer) \
    v(NativeFunction) \

#if ASSERT_ENABLED
    enum class ValueType {
#define DECLARE_TYPE(name) name,
        FOR_EACH_HASH_ATBLE_VALUE_TYPE(DECLARE_TYPE)
        End,
#undef DECLARE_TYPE
    };

#define DECLARE_TYPE() ValueType valueType;
#define INIT_TYPE(x) ValueType::x
#else
#define DECLARE_TYPE()
#define INIT_TYPE(x)
#endif // ASSERT_ENABLED

#define DECLARE_TAG(name) enum name##TypeTag { name##Type };
    FOR_EACH_HASH_ATBLE_VALUE_TYPE(DECLARE_TAG)
    enum EndTag { End };
#undef DECLARE_TAG

    ASCIILiteral m_key; // property name
    unsigned m_attributes; // JSObject attributes
    Intrinsic m_intrinsic;
    union ValueStorage {
        // PropertyAttribute::Accessor
        constexpr ValueStorage(AccessorTypeTag, NativeFunction::Ptr getter, NativeFunction::Ptr setter)
            : accessor({ getter, setter, INIT_TYPE(Accessor) })
        { }
        // PropertyAttribute::Builtin | PropertyAttribute::Accessor
        constexpr ValueStorage(BuiltinAccessorTypeTag, BuiltinGenerator getter, BuiltinGenerator setter)
            : builtinAccessor({ getter, setter, INIT_TYPE(BuiltinAccessor) })
        { }
        // PropertyAttribute::Builtin
        constexpr ValueStorage(BuiltinGeneratorTypeTag, BuiltinGenerator generator, intptr_t argCount)
            : builtinGenerator({ generator, argCount, INIT_TYPE(BuiltinGenerator) })
        { }
        // PropertyAttribute::ConstantInteger
        constexpr ValueStorage(ConstantTypeTag, long long constant)
            : constant({ constant, 0, INIT_TYPE(Constant) })
        { }
        // PropertyAttribute::DOMJITAttribute
        constexpr ValueStorage(DOMJITAttributeTypeTag, const DOMJIT::GetterSetter* getterSetter, PutValueFunc::Ptr setter)
            : domJITAttribute({ getterSetter, setter, INIT_TYPE(DOMJITAttribute) })
        { }
        // PropertyAttribute::Function | PropertyAttribute::DOMJITFunction
        constexpr ValueStorage(DOMJITFunctionTypeTag, NativeFunction::Ptr function, const DOMJIT::Signature* signature)
            : domJITFunction({ function, signature, INIT_TYPE(DOMJITFunction) })
        { }
        // PropertyAttribute::DOMAttribute
        constexpr ValueStorage(GetterSetterTypeTag, GetValueFunc::Ptr getter, PutValueFunc::Ptr setter)
            : getterSetter({ getter, setter, INIT_TYPE(GetterSetter) })
        { }
        constexpr ValueStorage(LazyCellPropertyTypeTag, ptrdiff_t offset)
            : lazyCellProperty({ offset, 0, INIT_TYPE(LazyCellProperty) })
        { }
        constexpr ValueStorage(LazyClassStructureTypeTag, ptrdiff_t offset)
            : lazyClassStructure({ offset, 0, INIT_TYPE(LazyClassStructure) })
        { }
        constexpr ValueStorage(LazyPropertyTypeTag, LazyPropertyCallback callback)
            : lazyProperty({ callback, 0, INIT_TYPE(LazyProperty) })
        { }
        constexpr ValueStorage(LexerTypeTag, intptr_t value)
            : lexer({ value, 0, INIT_TYPE(Lexer) })
        { }
        // PropertyAttribute::Function
        constexpr ValueStorage(NativeFunctionTypeTag, NativeFunction::Ptr function, intptr_t argCount)
            : nativeFunction({ function, argCount, INIT_TYPE(NativeFunction) })
        { }
        constexpr ValueStorage(EndTag)
            : bits({ 0, 0, INIT_TYPE(End) })
        { }

#define HASH_TABLE_VALUE_ATTR(discriminator) WTF_VTBL_FUNCPTR_PTRAUTH_STR("HashTableValue" #discriminator)

        struct {
            HASH_TABLE_VALUE_ATTR(Accessor) NativeFunction::Ptr getter;
            HASH_TABLE_VALUE_ATTR(Accessor) NativeFunction::Ptr setter;
            DECLARE_TYPE()
        } accessor;
        struct {
            HASH_TABLE_VALUE_ATTR(BuiltinAccessor) BuiltinGenerator getter;
            HASH_TABLE_VALUE_ATTR(BuiltinAccessor) BuiltinGenerator setter;
            DECLARE_TYPE()
        } builtinAccessor;
        struct {
            HASH_TABLE_VALUE_ATTR(BuiltinGenerator) BuiltinGenerator generator;
            intptr_t argCount;
            DECLARE_TYPE()
        } builtinGenerator;
        struct {
            long long value;
            intptr_t unused;
            DECLARE_TYPE()
        } constant;
        struct {
            const DOMJIT::GetterSetter* getterSetter;
            HASH_TABLE_VALUE_ATTR(DOMJITAttribute) PutValueFunc::Ptr setter;
            DECLARE_TYPE()
        } domJITAttribute;
        struct {
            HASH_TABLE_VALUE_ATTR(DOMJITFunction) NativeFunction::Ptr function;
            const DOMJIT::Signature* signature;
            DECLARE_TYPE()
        } domJITFunction;
        struct {
            HASH_TABLE_VALUE_ATTR(GetterSetter) GetValueFunc::Ptr getter;
            HASH_TABLE_VALUE_ATTR(GetterSetter) PutValueFunc::Ptr setter;
            DECLARE_TYPE()
        } getterSetter;
        struct {
            ptrdiff_t offset;
            intptr_t unused;
            DECLARE_TYPE()
        } lazyCellProperty;
        struct {
            ptrdiff_t offset;
            intptr_t unused;
            DECLARE_TYPE()
        } lazyClassStructure;
        struct {
            HASH_TABLE_VALUE_ATTR(LazyPropertyCallback) LazyPropertyCallback callback;
            intptr_t unused;
            DECLARE_TYPE()
        } lazyProperty;
        struct {
            intptr_t value;
            intptr_t unused;
            DECLARE_TYPE()
        } lexer;
        struct {
            HASH_TABLE_VALUE_ATTR(NativeFunction) NativeFunction::Ptr function;
            intptr_t argumentCount;
            DECLARE_TYPE()
        } nativeFunction;

#undef HASH_TABLE_VALUE_ATTR

        // Only used for null testing (e.g. hasGetter) and termination (e.g. the "End" entry).
        struct {
            intptr_t value1;
            intptr_t value2;
            DECLARE_TYPE()
        } bits;
    } m_values;

    unsigned attributes() const { return m_attributes; }

    Intrinsic intrinsic() const { ASSERT(m_attributes & PropertyAttribute::Function); return m_intrinsic; }
    BuiltinGenerator builtinGenerator() const
    {
        ASSERT(m_attributes & PropertyAttribute::Builtin);
        ASSERT(m_values.builtinGenerator.valueType == ValueType::BuiltinGenerator);
        return m_values.builtinGenerator.generator;
    }
    NativeFunction function() const
    {
        ASSERT(m_attributes & PropertyAttribute::Function);
        ASSERT(m_values.nativeFunction.valueType == ValueType::NativeFunction);
        return NativeFunction(m_values.nativeFunction.function);
    }
    unsigned char functionLength() const
    {
        ASSERT(m_attributes & PropertyAttribute::Function);
        if (m_attributes & PropertyAttribute::DOMJITFunction) {
            ASSERT(m_values.domJITFunction.valueType == ValueType::DOMJITFunction);
            return signature()->argumentCount;
        }
        ASSERT(m_values.nativeFunction.valueType == ValueType::NativeFunction);
        return static_cast<unsigned char>(m_values.nativeFunction.argumentCount);
    }

    bool hasGetter() const { return m_values.bits.value1; }
    bool hasSetter() const { return m_values.bits.value2; }

    GetValueFunc propertyGetter() const
    {
        ASSERT(!(m_attributes & PropertyAttribute::BuiltinOrFunctionOrAccessorOrLazyPropertyOrConstant));
        ASSERT(m_values.getterSetter.valueType == ValueType::GetterSetter);
        return GetValueFunc(m_values.getterSetter.getter);
    }
    PutValueFunc propertyPutter() const
    {
        ASSERT(!(m_attributes & PropertyAttribute::BuiltinOrFunctionOrAccessorOrLazyPropertyOrConstant));
        ASSERT(m_values.getterSetter.valueType == ValueType::GetterSetter);
        return PutValueFunc(m_values.getterSetter.setter);
    }

    NativeFunction domJITFunction() const
    {
        ASSERT(m_attributes & PropertyAttribute::Function);
        ASSERT(m_values.nativeFunction.valueType == ValueType::DOMJITFunction);
        return NativeFunction(m_values.domJITFunction.function);
    }

    const DOMJIT::GetterSetter* domJIT() const
    {
        ASSERT(m_attributes & PropertyAttribute::DOMJITAttribute);
        ASSERT(m_values.domJITAttribute.valueType == ValueType::DOMJITAttribute);
        return m_values.domJITAttribute.getterSetter;
    }
    PutValueFunc domJITSetter() const
    {
        ASSERT(m_attributes & PropertyAttribute::DOMJITAttribute);
        ASSERT(m_values.domJITAttribute.valueType == ValueType::DOMJITAttribute);
        return m_values.domJITAttribute.setter;
    }
    const DOMJIT::Signature* signature() const
    {
        ASSERT(m_attributes & PropertyAttribute::DOMJITFunction);
        ASSERT(m_values.domJITFunction.valueType == ValueType::DOMJITFunction);
        return m_values.domJITFunction.signature;
    }

    NativeFunction accessorGetter() const
    {
        ASSERT(m_attributes & PropertyAttribute::Accessor);
        ASSERT(m_values.accessor.valueType == ValueType::Accessor);
        return NativeFunction(m_values.accessor.getter);
    }
    NativeFunction accessorSetter() const
    {
        ASSERT(m_attributes & PropertyAttribute::Accessor);
        ASSERT(m_values.accessor.valueType == ValueType::Accessor);
        return NativeFunction(m_values.accessor.setter);
    }
    BuiltinGenerator builtinAccessorGetterGenerator() const;
    BuiltinGenerator builtinAccessorSetterGenerator() const;

    long long constantInteger() const
    {
        ASSERT(m_attributes & PropertyAttribute::ConstantInteger);
        ASSERT(m_values.constant.valueType == ValueType::Constant);
        return m_values.constant.value;
    }

    intptr_t lexerValue() const
    {
        ASSERT(!m_attributes);
        ASSERT(m_values.lexer.valueType == ValueType::Lexer);
        return m_values.lexer.value;
    }

    ptrdiff_t lazyCellPropertyOffset() const
    {
        ASSERT(m_attributes & PropertyAttribute::CellProperty);
        ASSERT(m_values.lazyCellProperty.valueType == ValueType::LazyCellProperty);
        return m_values.lazyCellProperty.offset;
    }
    ptrdiff_t lazyClassStructureOffset() const
    {
        ASSERT(m_attributes & PropertyAttribute::ClassStructure);
        ASSERT(m_values.lazyClassStructure.valueType == ValueType::LazyClassStructure);
        return m_values.lazyClassStructure.offset;
    }
    LazyPropertyCallback lazyPropertyCallback() const
    {
        ASSERT(m_attributes & PropertyAttribute::PropertyCallback);
        ASSERT(m_values.lazyProperty.valueType == ValueType::LazyProperty);
        return m_values.lazyProperty.callback;
    }
};

struct HashTable {
    int numberOfValues;
    int indexMask;
    uint8_t seenPropertyAttributes;
    const ClassInfo* classForThis; // Used by DOMAttribute. Attribute accessors perform type check against this classInfo.

    const HashTableValue* values; // Fixed values generated by script.
    const CompactHashIndex* index;

    // Find an entry in the table, and return the entry.
    ALWAYS_INLINE const HashTableValue* entry(PropertyName propertyName) const
    {
        if (propertyName.isSymbol())
            return nullptr;

        auto uid = propertyName.uid();
        if (!uid)
            return nullptr;

        int indexEntry = IdentifierRepHash::hash(uid) & indexMask;
        int valueIndex = index[indexEntry].value;
        if (valueIndex == -1)
            return nullptr;

        while (true) {
            if (!values[valueIndex].m_key.isNull() && WTF::equal(uid, values[valueIndex].m_key))
                return &values[valueIndex];

            indexEntry = index[indexEntry].next;
            if (indexEntry == -1)
                return nullptr;
            valueIndex = index[indexEntry].value;
            ASSERT(valueIndex != -1);
        };
    }

    class ConstIterator {
    public:
        ConstIterator(const HashTable* table, int position)
            : m_table(table)
            , m_position(position)
        {
            skipInvalidKeys();
        }

        const HashTableValue* value() const
        {
            return &m_table->values[m_position];
        }

        const HashTableValue& operator*() const { return *value(); }

        ASCIILiteral key() const
        {
            return m_table->values[m_position].m_key;
        }

        const HashTableValue* operator->() const
        {
            return value();
        }

        bool operator==(const ConstIterator& other) const
        {
            ASSERT(m_table == other.m_table);
            return m_position == other.m_position;
        }

        ConstIterator& operator++()
        {
            ASSERT(m_position < m_table->numberOfValues);
            ++m_position;
            skipInvalidKeys();
            return *this;
        }

    private:
        void skipInvalidKeys()
        {
            ASSERT(m_position <= m_table->numberOfValues);
            while (m_position < m_table->numberOfValues && m_table->values[m_position].m_key.isNull())
                ++m_position;
            ASSERT(m_position <= m_table->numberOfValues);
        }

        const HashTable* m_table;
        int m_position;
    };

    ConstIterator begin() const
    {
        return ConstIterator(this, 0);
    }
    ConstIterator end() const
    {
        return ConstIterator(this, numberOfValues);
    }
};

JS_EXPORT_PRIVATE bool setUpStaticFunctionSlot(VM&, const ClassInfo*, const HashTableValue*, JSObject* thisObject, PropertyName, PropertySlot&);
JS_EXPORT_PRIVATE void reifyStaticAccessor(VM&, const HashTableValue&, JSObject& thisObject, PropertyName);

inline BuiltinGenerator HashTableValue::builtinAccessorGetterGenerator() const
{
    ASSERT(m_attributes & PropertyAttribute::Accessor);
    ASSERT(m_attributes & PropertyAttribute::Builtin);
    ASSERT(m_values.builtinAccessor.valueType == ValueType::BuiltinAccessor);
    return reinterpret_cast<BuiltinGenerator>(m_values.builtinAccessor.getter);
}

inline BuiltinGenerator HashTableValue::builtinAccessorSetterGenerator() const
{
    ASSERT(m_attributes & PropertyAttribute::Accessor);
    ASSERT(m_attributes & PropertyAttribute::Builtin);
    ASSERT(m_values.builtinAccessor.valueType == ValueType::BuiltinAccessor);
    return reinterpret_cast<BuiltinGenerator>(m_values.builtinAccessor.setter);
}

inline bool getStaticPropertySlotFromTable(VM& vm, const ClassInfo* classInfo, const HashTable& table, JSObject* thisObject, PropertyName propertyName, PropertySlot& slot)
{
    if (thisObject->staticPropertiesReified())
        return false;

    auto* entry = table.entry(propertyName);
    if (!entry)
        return false;

    if (entry->attributes() & PropertyAttribute::BuiltinOrFunctionOrAccessorOrLazyProperty)
        return setUpStaticFunctionSlot(vm, classInfo, entry, thisObject, propertyName, slot);

    if (entry->attributes() & PropertyAttribute::ConstantInteger) {
        slot.setValue(thisObject, attributesForStructure(entry->attributes()), jsNumber(entry->constantInteger()));
        return true;
    }

    if (entry->attributes() & PropertyAttribute::DOMJITAttribute) {
        ASSERT_WITH_MESSAGE(entry->attributes() & PropertyAttribute::ReadOnly, "DOMJITAttribute supports readonly attributes currently.");
        const DOMJIT::GetterSetter* domJIT = entry->domJIT();
        slot.setCacheableCustom(thisObject, attributesForStructure(entry->attributes()), domJIT->getter(), entry->domJITSetter(), DOMAttributeAnnotation { classInfo, domJIT });
        return true;
    }

    if (entry->attributes() & PropertyAttribute::DOMAttribute) {
        slot.setCacheableCustom(thisObject, attributesForStructure(entry->attributes()), entry->propertyGetter(), entry->propertyPutter(), DOMAttributeAnnotation { classInfo, nullptr });
        return true;
    }

    slot.setCacheableCustom(thisObject, attributesForStructure(entry->attributes()), entry->propertyGetter(), entry->propertyPutter());
    return true;
}

inline void reifyStaticProperty(VM& vm, const ClassInfo* classInfo, const PropertyName& propertyName, const HashTableValue& value, JSObject& thisObj)
{
    if (value.attributes() & PropertyAttribute::Builtin) {
        if (value.attributes() & PropertyAttribute::Accessor)
            reifyStaticAccessor(vm, value, thisObj, propertyName);
        else
            thisObj.putDirectBuiltinFunction(vm, thisObj.globalObject(), propertyName, value.builtinGenerator()(vm), attributesForStructure(value.attributes()));
        return;
    }

    if (value.attributes() & PropertyAttribute::Function) {
        if (value.attributes() & PropertyAttribute::DOMJITFunction) {
            thisObj.putDirectNativeFunction(
                vm, thisObj.globalObject(), propertyName, value.functionLength(),
                value.domJITFunction(), ImplementationVisibility::Public, value.intrinsic(), value.signature(), attributesForStructure(value.attributes()));
            return;
        }
        thisObj.putDirectNativeFunction(
            vm, thisObj.globalObject(), propertyName, value.functionLength(),
            value.function(), ImplementationVisibility::Public, value.intrinsic(), attributesForStructure(value.attributes()));
        return;
    }

    if (value.attributes() & PropertyAttribute::ConstantInteger) {
        thisObj.putDirect(vm, propertyName, jsNumber(value.constantInteger()), attributesForStructure(value.attributes()));
        return;
    }

    if (value.attributes() & PropertyAttribute::Accessor) {
        reifyStaticAccessor(vm, value, thisObj, propertyName);
        return;
    }

    if (value.attributes() & PropertyAttribute::CellProperty) {
        LazyCellProperty* property = bitwise_cast<LazyCellProperty*>(
            bitwise_cast<char*>(&thisObj) + value.lazyCellPropertyOffset());
        JSCell* result = property->get(&thisObj);
        thisObj.putDirect(vm, propertyName, result, attributesForStructure(value.attributes()));
        return;
    }

    if (value.attributes() & PropertyAttribute::ClassStructure) {
        LazyClassStructure* lazyStructure = bitwise_cast<LazyClassStructure*>(
            bitwise_cast<char*>(&thisObj) + value.lazyClassStructureOffset());
        JSObject* constructor = lazyStructure->constructor(jsCast<JSGlobalObject*>(&thisObj));
        thisObj.putDirect(vm, propertyName, constructor, attributesForStructure(value.attributes()));
        return;
    }

    if (value.attributes() & PropertyAttribute::PropertyCallback) {
        JSValue result = value.lazyPropertyCallback()(vm, &thisObj);
        thisObj.putDirect(vm, propertyName, result, attributesForStructure(value.attributes()));
        return;
    }

    if (value.attributes() & PropertyAttribute::DOMJITAttribute) {
        ASSERT_WITH_MESSAGE(classInfo, "DOMJITAttribute should have class info for type checking.");
        const DOMJIT::GetterSetter* domJIT = value.domJIT();
        auto* customGetterSetter = DOMAttributeGetterSetter::create(vm, domJIT->getter(), value.domJITSetter(), DOMAttributeAnnotation { classInfo, domJIT });
        thisObj.putDirectCustomAccessor(vm, propertyName, customGetterSetter, attributesForStructure(value.attributes()));
        return;
    }

    if (value.attributes() & PropertyAttribute::DOMAttribute) {
        ASSERT_WITH_MESSAGE(classInfo, "DOMAttribute should have class info for type checking.");
        auto* customGetterSetter = DOMAttributeGetterSetter::create(vm, value.propertyGetter(), value.propertyPutter(), DOMAttributeAnnotation { classInfo, nullptr });
        thisObj.putDirectCustomAccessor(vm, propertyName, customGetterSetter, attributesForStructure(value.attributes()));
        return;
    }

    CustomGetterSetter* customGetterSetter = CustomGetterSetter::create(vm, value.propertyGetter(), value.propertyPutter());
    thisObj.putDirectCustomAccessor(vm, propertyName, customGetterSetter, attributesForStructure(value.attributes()));
}

template<unsigned numberOfValues>
inline void reifyStaticProperties(VM& vm, const ClassInfo* classInfo, const HashTableValue (&values)[numberOfValues], JSObject& thisObj)
{
    BatchedTransitionOptimizer transitionOptimizer(vm, &thisObj);
    for (auto& value : values) {
        if (value.m_key.isNull())
            continue;
        auto key = Identifier::fromString(vm, value.m_key);
        reifyStaticProperty(vm, classInfo, key, value, thisObj);
    }
}

} // namespace JSC