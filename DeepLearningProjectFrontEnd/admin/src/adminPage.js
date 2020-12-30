import * as React from "react";
import {Admin, Resource,Login } from 'react-admin';
import Dashboard from './Dashboard';
import authProvider from './authProvider';
import {MemberCreate, MemberEdit, MemberList} from './memberTable';
import {StateList, StateEdit, StateCreate} from './stateTable';
import {AdminList, AdminEdit, AdminCreate} from './adminTable';
import dataProv from './dataProv';
import { createMuiTheme } from '@material-ui/core/styles';
import homeImg from './photo/homeimg.png'; //loginimage
const dataProvider = dataProv;

const theme = createMuiTheme({
    palette: {
      type: 'dark', // Switching the dark mode on is a single property value change.
      secondary: {
        main: '#01060A',
      },
    },
  });

  const MyLoginPage = () => (
    <Login
        backgroundImage= {homeImg}
    />
);

export const adminPage = () => (
    <Admin dashboard={Dashboard} authProvider={authProvider} dataProvider={dataProvider} theme={theme} loginPage={MyLoginPage}>
        <Resource name="member" list={MemberList} edit= {MemberEdit} create = {MemberCreate}/>
        <Resource name="state" list={StateList} edit= {StateEdit} create = {StateCreate}/>
        <Resource name="admin" list={AdminList} edit= {AdminEdit} create = {AdminCreate} />
    </Admin>
)

export default adminPage
