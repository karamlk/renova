import "./Users.css";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useEffect,useContext } from "react";
//api
import {getUsersRequest} from "../../api/users";
import {getUserProfileRequest} from "../../api/userProfile";
import {deleteUserRequest} from "../../api/deleteUser";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//MUI Icons
import GroupIcon from '@mui/icons-material/Group';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import RefreshIcon from '@mui/icons-material/Refresh';
import VisibilityIcon from '@mui/icons-material/Visibility';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import IconButton from '@mui/material/IconButton';
import Tooltip from '@mui/material/Tooltip';
import Avatar from '@mui/material/Avatar';
import AddIcon from '@mui/icons-material/Add';
import Switch from '@mui/material/Switch';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
//Commponents
import Profiledialog from "../../components/Profiledialog/Profiledialog";
import Confirmdialog from "../../components/Confirmdialog/Confirmdialog";
import Snackbar from "../../components/Snackbar/Snakbar";

export default function User(){
    const [t] = useTranslation();
    const [users,setUsers] = useState([]);
    const [profileload,setprofileload] = useState(false);
    const [userinfo,setUserinfo] = useState({});
    const [showprofile, setshowprofile] = useState(false);
    const [showconfirmdialog, setshowconfirmdialog] = useState(false);
    const [selectedUserId, setSelectedUserId] = useState(null);
    const [deletemsg,setdeletemsg] = useState();
    const [isopen, setisopen] = useState(false);
    
    
    const {setisloading}=useContext(LoadingContext);
    let role ={ 1:t("مدير النظام"), 2:t("مستخدم"), 3:t("متعهد"), 4:t("مهندس")}
    let status ={ approved:t("مقبول"), rejected:t("مرفوض"), pending:t("قيد الانتظار")}
    //Request
    async function getUsers() {
            setisloading(true);
            await new Promise(resolve => setTimeout(resolve, 1500));
            try{            
                let response = await getUsersRequest();
                setUsers(response.data.data);
            }finally{
                setisloading(false);
             }
            }
    async function showUser(id) {
            setprofileload(true);
            setUserinfo({});    
            let response = await getUserProfileRequest(id);
            setUserinfo(response.data.data);
            setprofileload(false); 
    }
    async function deleteUser(id) {
            setprofileload(true);
            let response = await deleteUserRequest(id);
            setdeletemsg(response.data.message);
            await getUsers();
            setprofileload(false);
            setisopen(true);
    }
    useEffect(()=>{getUsers();},[]);
    return(
        <div>  
        {profileload ? (<div className="page"></div>):(
            showprofile && (<Profiledialog
         name={userinfo?.name}
         first_name={userinfo?.profile?.first_name}
         last_name={userinfo?.profile?.last_name}
         image={userinfo?.profile?.full_image_url ? <Avatar  src={userinfo?.profile?.full_image_url} alt="img" sx={{ width: 80, height: 80 }} /> :<AccountCircleIcon  sx={{ color: '#f07c1f' ,fontSize:"80px" }} />}
         email={userinfo?.email}
         phone={userinfo?.profile?.phone}
         location={userinfo?.profile?.location}
         role={role[userinfo?.role_id]}
         onClose={() => setshowprofile(false)}
          />)
        )}
        {showconfirmdialog && (<Confirmdialog
         icon={<DeleteIcon sx={{ color: "#e53935" ,fontSize:65 }}/>}
         title={t("تأكيد الحذف")}
         message={t("هل تريد حذف هذا المستخدم؟")}
         name_btn1={t("إلغاء")}
         name_btn2={t("حذف")}
         onClose={() => setshowconfirmdialog(false)}
         onConfirm={() => deleteUser(selectedUserId)}
        />)}
            <Snackbar msg={deletemsg} isopen={isopen} setisopen={setisopen}/>
            <div className="users-table">
            <div className="table-header">
                <h3><GroupIcon sx={{ color: "#f07c1f"}}/> {t("المستخدمين")}</h3>
                <div className="table-actions">
                    <button className="btn-filter"><FilterAltIcon sx={{fontSize: "18px"}}/> {t("فلترة")}</button>
                    <button className="btn-refresh" onClick={getUsers}><RefreshIcon sx={{fontSize: "18px"}}/> {t("تحديث")}</button>
                    {/*<button className="btn-add"><AddIcon sx={{fontSize: "18px"}}/> {t("إضافة")}</button>*/}
                </div>
            </div>
            <div className="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>{t("الصورة")}</th>
                            <th>{t("اسم المستخدم")}</th>
                            <th>{t("رقم الجوال")}</th>
                            <th>{t("مكان السكن")}</th>
                            <th>{t("الدور")}</th>
                            <th>{t("تاريخ الإنشاء")}</th>
                            <th>{t("الحالة")}</th>
                            <th>{t("نشط")}</th>
                            <th>{t("الاجراءات")}</th>
                        </tr>
                    </thead>
                   <tbody>
                    {users.map((user) => (
                        <tr key={user.id}>
                        <td>
                            <div className="avatar">
                                {user?.profile?.full_image_url ? <Avatar  src={user?.profile?.full_image_url} alt="img" sx={{ width: 50, height: 50 }} />:<Avatar  alt=""  sx={{ width: 48, height: 48 , color: "#f07c1f", backgroundColor: "rgba(240, 124, 31, 0.1)"   }} />   }
                            
                            </div>
                        </td>
                        <td>{user?.name} </td>
                        <td>{user?.profile?.phone? user?.profile?.phone : t("غير موجود")}</td>
                        <td className="location"><LocationOnIcon sx={{ color: "#f07c1f"}}/>{user?.profile?.location ? user?.profile?.location : t("غير موجود")}</td>
                        <td>{role[user?.role_id]}</td>
                        <td>{user?.created_at}</td>
                        <td>{status[user?.status]}</td>
                        <td><Switch checked={user?.is_active} color="warning" /></td>
                        <td>
                            <div className="actions">
                            {/* زر العرض */}
                            <Tooltip title={t("عرض")} arrow>
                                <IconButton className="action-btn" sx={{
                                        color: "#2196f3",
                                        backgroundColor: "rgba(33,150,243,0.1)",
                                        "&:hover": {
                                        backgroundColor: "#2196f3",
                                        color: "white",
                                        },
                                    }} onClick={() =>{setshowprofile(true);showUser(user.id);}}>
                                <VisibilityIcon sx={{ fontSize: 24 }} />
                                </IconButton>
                            </Tooltip>

                            {/* زر التعديل */}
                           {/*<Tooltip title={t("تعديل")} arrow>


                                <IconButton className="action-btn " sx={{
                                        color: "#f07c1f",
                                        backgroundColor: "rgba(240,124,31,0.1)",
                                        "&:hover": {
                                            backgroundColor: "#f07c1f",
                                            color: "white",
                                        },
                                        }}>
                                <EditIcon sx={{ fontSize: 24 }} />
                                </IconButton>
                            </Tooltip>*/} 

                            {/* زر الحذف */}
                            <Tooltip title={t("حذف")} arrow>
                                <IconButton className="action-btn" sx={{
                                        color: "#e53935",
                                        backgroundColor: "rgba(229,57,53,0.1)",
                                        "&:hover": {
                                            backgroundColor: "#e53935",
                                            color: "white",
                                        },
                                        }} onClick={()=>{setSelectedUserId(user.id);setshowconfirmdialog(true)}}>
                                <DeleteIcon sx={{ fontSize: 24 }} />
                                </IconButton>
                            </Tooltip>
                            </div>
                        </td>
                        </tr>
                    ))}
                    </tbody>
                </table>
            </div>
        </div>
        </div>
    );
}