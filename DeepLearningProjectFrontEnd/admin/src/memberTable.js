import * as React from "react";
import {SearchInput, PasswordInput, Create, EditButton, Filter, TextInput, ReferenceInput, SelectInput, ImageField, List, Datagrid, TextField, ImageInput,SimpleForm,Edit} from 'react-admin';
// ReferenceField의 source는 forignkey, reference는 참조할 테이블 명시하는 것
const PostFilter = props => (
    <Filter {...props}>
        <SearchInput source="q" alwaysOn/>
    </Filter>
);

export const MemberList = props => (
<List {...props} filters={<PostFilter/>} exporter={false} >
        <Datagrid rowClick="edit">
            <TextField source="id" label = "번호"/>
            <TextField source="memberId" sortable = {false} label = "아이디"/>
            <TextField source="memberName" sortable = {false} label = "이름"/>
            <TextField source="memberCount" label = "벌점"/>
            <ImageField source="memberFace" sortable = {false} label = "사진"/>
            <EditButton/>
        </Datagrid>
    </List>
);

export const MemberEdit = props => (
    <Edit {...props} undoable = {false} >
        <SimpleForm>
            <TextInput disabled source="id" />
            <TextInput disabled source="memberId" />
            <PasswordInput source="memberPw" />
            <TextInput source="memberName" />
            <TextInput multiline disabled source="memberCount" />
            <ImageField source="memberFace" />
            <ImageInput source="updateMemberFace" maxSize = {800000} accept = "image/*" multiple = {false} >
                <ImageField src = "src" source="updateMemberFace" />
            </ImageInput>
        </SimpleForm>
    </Edit>
);

export const MemberCreate = props => (
    <Create {...props}>
        <SimpleForm>
            <TextInput source="memberId" />
            <PasswordInput source="memberPw" />
            <TextInput source="memberName" />
            <TextInput multiline = {false} source="memberCount" />
            <ImageInput source="memberFace" maxSize = {800000} accept = "image/*" multiple = {false} >
                <ImageField src = "src" source="memberFace"/>
            </ImageInput>
        </SimpleForm>
    </Create>
);