import { fetchUtils } from "react-admin";
//import jsonServerProvider from 'ra-data-json-server';
import jsonServerProvider from "./basicStructureOfProvider";
const servicesHost = 'http://54.180.165.95:8082';

const httpClient = (url, options = {}) => {
    if (!options.headers) {
        options.headers = new Headers({ Accept: 'application/json' });
    }
    options.headers.set('Access-Control-Expose-Headers','X-Total-Count');
    return fetchUtils.fetchJson(url, options);
};

const dataProvider = jsonServerProvider(servicesHost, httpClient);

const dataProv = {
    ...dataProvider, //확산연산자
    create: (resource, params) => {
        if (resource === 'member') {
            const formData = new FormData();
            const myFile = new File([params.data.memberFace.rawFile],params.data.memberFace.rawFile.name,{ type: params.data.memberFace.rawFile.type});
            formData.append('memberFace',myFile);
            formData.append('memberName', params.data.memberName);
            formData.append('memberCount',params.data.memberCount);
            
            return fetch(servicesHost+'/'+resource, {
                method: 'post',
                body: formData,
            })
                .then(response => response.json())
                .then(member => dataProvider.create(resource, member));
        }
        return dataProvider.create(resource, params);
    },
    update: (resource, params) => {
        if (resource === 'member') {
            const formData = new FormData();
            if(!params.data.updateMemberFace){
                console.log("====== Picture Not Found =====");
            }else{
                const myFile = new File([params.data.updateMemberFace.rawFile],params.data.updateMemberFace.rawFile.name,{ type: params.data.updateMemberFace.rawFile.type});
                formData.append('updateMemberFace',myFile);
            }
            formData.append('memberName', params.data.memberName);
            formData.append('memberCount',params.data.memberCount);
            return fetch(servicesHost+'/'+resource +'/' + params.id, {
                method: 'put',
                body: formData,
            })
            .then(response => response.json())
            .then(member => dataProvider.update(resource, member));
        }
        return dataProvider.update(resource, params);
    },

};

export default dataProv;
