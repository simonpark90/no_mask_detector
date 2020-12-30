import { fetchUtils } from 'ra-core';

export default {
    // called when the user attempts to log in
    login: ({ username, password }) => {
        const httpClient = fetchUtils.fetchJson;
        const formData = new FormData();
        formData.append('username', username);
        formData.append('password', password);
        const servicesHost = 'http://54.180.165.95:8082';
        return httpClient(servicesHost + '/memberlogin',{
            method : 'post',
            body : JSON.stringify({"username" : username})
        })
        .then(function(res){
            const json = res.json;
            if(json.memberId === username && json.memberPw === password ){
                localStorage.setItem('username', username);
                // accept all username/password combinations
                return Promise.resolve();
            }else{
                return Promise.reject();
            }
        })
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
		const auth = localStorage.getItem('username');
        const servicesHost = 'http://54.180.165.95:8082';
		const httpClient = fetchUtils.fetchJson;
		return httpClient(servicesHost+'/member',{
			method : 'get',
		}).then(function(res){
			const json = res.json;
			for(let i = 0 ; i < json.length; i++){
				if(json[i].memberId === auth){
					return Promise.resolve();
				}
			}
			localStorage.removeItem('username');
			return Promise.reject();
		})

    },
    // called when the user navigates to a new location, to check for permissions / roles
    getPermissions: () => Promise.resolve(),
};
