import * as React from "react";
import {Admin, Resource } from 'react-admin';
import Dashboard from './Dashboard';
import authProvider from './authProvider';
import {MemberCreate, MemberEdit, MemberList} from './memberTable';
import {StateList, StateEdit, StateCreate} from './stateTable';
import {AdminList, AdminEdit, AdminCreate} from './adminTable';
import dataProv from './dataProv';

const dataProvider = dataProv;
export const adminPage = () => (
    <Admin dashboard={Dashboard} authProvider={authProvider} dataProvider={dataProvider}>
        <Resource name="member" list={MemberList} edit= {MemberEdit} create = {MemberCreate}/>
        <Resource name="state" list={StateList} edit= {StateEdit} create = {StateCreate}/>
        <Resource name="admin" list={AdminList} edit= {AdminEdit} create = {AdminCreate} />
    </Admin>
)

export default adminPage
