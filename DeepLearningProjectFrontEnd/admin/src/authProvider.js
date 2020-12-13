import { fetchUtils } from 'ra-core';

export default {
    // called when the user attempts to log in
    login: ({ username, password }) => {
        if('master' === username && 'master' === password ){
            localStorage.setItem('username', username);
            // accept all username/password combinations
            return Promise.resolve();
        }else{
            const httpClient = fetchUtils.fetchJson;
            const formData = new FormData();
            formData.append('username', username);
            formData.append('password', password);
            const servicesHost = 'http://54.180.165.95:8082';
            return httpClient(servicesHost + '/login',{
                method : 'post',
                body : JSON.stringify({"username" : username})
            })
            .then(function(res){
                const json = res.json;
                if(json.adminId === username && json.adminPw === password ){
                    localStorage.setItem('username', username);
                    // accept all username/password combinations
                    return Promise.resolve();
                }else{
                    return Promise.reject();
                }
            })
        }
    }, 
    // called when the user clicks on the logout button
    logout: () => {
        localStorage.removeItem('username');
        return Promise.resolve();
    },
    // called when the API returns an error
    checkError: ({ status }) => {
        if (status === 401 || status === 403) {
            localStorage.removeItem('username');
            return Promise.reject();
        }
        return Promise.resolve();
    },
    // called when the user navigates to a new location, to check for authentication
    checkAuth: () => {
        return localStorage.getItem('username')
            ? Promise.resolve()
            : Promise.reject();
    },
    // called when the user navigates to a new location, to check for permissions / roles
    getPermissions: () => Promise.resolve(),
};
