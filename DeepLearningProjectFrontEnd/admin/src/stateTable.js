import * as React from "react";
import {SearchInput, ImageField,ReferenceField, Create, EditButton, Filter, TextInput, ReferenceInput, SelectInput,List, Datagrid, TextField, SimpleForm,Edit} from 'react-admin';
// ReferenceField의 source는 forignkey, reference는 참조할 테이블 명시하는 것
const PostFilter = props => (
    <Filter {...props}>
        <SearchInput source="q" alwaysOn/>
    </Filter>
);

export const StateList = props => (
    <List {...props} filters={<PostFilter/>} exporter={false}>
        <Datagrid rowClick="edit">
            <TextField source="id" label = "번호" />
            <ReferenceField label="MemberId" source="MemberId" reference="member" sortable = {false} label = "멤버 번호">
                <TextField source = "id" />
            </ReferenceField>
            <ReferenceField label="MemberName" source="MemberId" reference="member" sortable = {false} label = "멤버 이름">
                <TextField source = "memberName" />
            </ReferenceField>
            <TextField source="stateNote" sortable = {false} label = "비고"/>
            <TextField source="stateTime" sortable = {false} label = "생성시간"/>
	<ImageField source="stateFace" sortable = {false} label = "적발 사진"/>
            <EditButton/>
        </Datagrid>
    </List>
);
export const StateEdit = props => (
    <Edit {...props} undoable = {false} >
        <SimpleForm>
            <ReferenceField label="MemberId" source="MemberId" reference="member">
                <TextField source = "id" />
            </ReferenceField>
            <ReferenceField label="memberName" source="MemberId" reference="member">
                <TextField source = "memberName" />
            </ReferenceField>
            <ReferenceField label="MemberFace" source="MemberId" reference="member">
                <ImageField source = "memberFace" />
            </ReferenceField>
	<ImageField source="stateFace" />
            <TextInput disabled source="id" />
            <TextInput source="stateNote" />
        </SimpleForm>
    </Edit>
);
export const StateCreate = props => (
    <Create {...props}>
        <SimpleForm>
            <TextInput source="stateNote" />
            <TextInput label="MemberId" source="memberId" />
        </SimpleForm>
    </Create>
);