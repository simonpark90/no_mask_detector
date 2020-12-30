import * as React from "react";
import {SearchInput, PasswordInput ,Create, EditButton, Filter, TextInput, ReferenceInput, SelectInput,List, Datagrid, TextField, SimpleForm,Edit} from 'react-admin';
// ReferenceField의 source는 forignkey, reference는 참조할 테이블 명시하는 것
const PostFilter = props => (
    <Filter {...props}>
        <SearchInput source="q" alwaysOn/>
    </Filter>
);

export const AdminList = props => (
    <List {...props} filters={<PostFilter/>} exporter={false} bulkActionButtons = {false}>
        <Datagrid rowClick="edit">
            <TextField source="id" label = "번호" />
            <TextField source="adminId" sortable = {false} label = "관리자 아이디"/>
            <TextField source="adminPhoneNum" sortable = {false} label = "전화번호"/>
            <EditButton/>
        </Datagrid>
    </List>
);
export const AdminEdit = props => (
    <Edit {...props} undoable = {false} >
        <SimpleForm>
            <TextInput disabled source="id" />
            <TextInput source="adminId" />
            <TextInput source="adminPhoneNum" />
            <PasswordInput source="existingPw" />
            <PasswordInput source="adminPw" />
        </SimpleForm>
    </Edit>
);
export const AdminCreate = props => (
    <Create {...props}>
        <SimpleForm>
            <TextInput source="adminId" />
            <TextInput source="adminPhoneNum" />
            <PasswordInput source="adminPw" />
        </SimpleForm>
    </Create>
);
