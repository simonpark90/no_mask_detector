import * as React from "react";
import { List, TextField, useListContext} from "react-admin";
// import { connect } from "react-redux";
import { makeStyles } from '@material-ui/core/styles';
import { Card,CardHeader, Avatar, CardMedia } from '@material-ui/core';
import PersonIcon from '@material-ui/icons/Person'; 

const WebFont = require('webfontloader');

WebFont.load({
    google: {
        families: 'Do Hyeon'
    }
});

const useStyles = makeStyles((theme) => ({
    root:{
        paddingTop: '50px',
        paddingRight: '25px',
        paddingBottom: '50px',
        paddingLeft: '50px',
    },
    card: {
        maxWidth: 230,
        width:230,
        height:290,
        margin: '20px',
        display: 'inline-block',
        verticalAlign: 'top',
        backgroundColor: 'white',
        boxShadow: '0 8px 24px 0 rgba(0,0,0,0.12)', 
        overflow: 'visible', 
        borderRadius: '1.5rem', 
        // alignSelf: "center"
    },
    media: {
        height: '67%',
    },
    profile: {
        fontFamily: 'Do Hyeon', 
        fontSize: '1rem', 
        fontWeight: 600,
        color : 'black'
    },
    avatar: {
        // backgroundColor: 'red',
    },
}));
//Custom Iterator
const ImageGrid = () => {
    //ids is an array of the ids currently displayed in the list
    //data is an object of all the fetched data for this resource, indexed by id.
    const { ids, data, basePath } = useListContext(); 
    
    const classes = useStyles();
    return (
        <div className={classes.root}>
            {ids.map(id =>
                <Card key={id} className={classes.card}>
                    <CardHeader
                        title={<TextField record={data[id]} source="memberName" className={classes.profile} sortable = {false} />}
                        avatar={<Avatar icon={<PersonIcon />} className={classes.avatar} />}
                    />
                    <CardMedia
                        className={classes.media} component="img" image={data[id].memberFace} alt="memberFace img"
                    />
                </Card>
            )}
        </div>
    );
};

export const UsersList = ({ groupNameFilter, ...props }) => {

    return (
        <React.Fragment>
            <List {...props} bulkActionButtons={false} sort={{ field: 'memberCount', order: 'DESC' }} perPage={3} pagination={false} exporter={false}>
                <ImageGrid />
            </List>
        </React.Fragment>
    );
};

export default UsersList;
