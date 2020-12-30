import * as React from "react";
import {Admin, Resource,Login} from 'react-admin';
import authProvider from './memberAuthProvider';
import dataProv from './dataProv';
import Userboard from "./Userboard";
import {UserList} from "./userTable";
import { createMuiTheme } from '@material-ui/core/styles';
import homeImg from './photo/homeimg.png';

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

export const UserPage = () => {
    return (
        <div>
            <Admin dashboard={Userboard} authProvider={authProvider} dataProvider={dataProvider} theme={theme} loginPage={MyLoginPage}>
                <Resource name="member" list={UserList}/>
            </Admin>
        </div>
    )
};

export default UserPage
