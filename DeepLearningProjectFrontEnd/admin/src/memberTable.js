import * as React from "react";
import {Create, EditButton, Filter, TextInput, ReferenceInput, SelectInput, ImageField, List, Datagrid, TextField, ImageInput,SimpleForm,Edit} from 'react-admin';
// ReferenceField의 source는 forignkey, reference는 참조할 테이블 명시하는 것


export const MemberList = props => (
    <List {...props}>
        <Datagrid rowClick="edit">
            <TextField source="id" />
            <TextField source="memberName" />
            <TextField source="memberCount" />
            <ImageField source="memberFace" />
            <EditButton/>
        </Datagrid>
    </List>
);

export const MemberEdit = props => (
    <Edit {...props} undoable = {false} >
        <SimpleForm>
            <TextInput disabled source="id" />
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
            <TextInput source="memberName" />
            <TextInput multiline = {false} source="memberCount" />
            <ImageInput source="memberFace" maxSize = {800000} accept = "image/*" multiple = {false} >
                <ImageField src = "src" source="memberFace"/>
            </ImageInput>
        </SimpleForm>
    </Create>
);