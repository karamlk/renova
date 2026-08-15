import "./Users.css";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useEffect,useContext } from "react";
//api
import {getUsersRequest} from "../../api/users";
import {getUserProfileRequest} from "../../api/users";
import {deleteUserRequest} from "../../api/users";
import {editActivationRequest} from "../../api/activation";
import {getFilterUsersRequest} from "../../api/users";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//MUI Icons
import GroupIcon from '@mui/icons-material/Group';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import RefreshIcon from '@mui/icons-material/Refresh';
import VisibilityIcon from '@mui/icons-material/Visibility';
import DeleteIcon from '@mui/icons-material/Delete';
import Avatar from '@mui/material/Avatar';
import Switch from '@mui/material/Switch';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
import PersonIcon from '@mui/icons-material/Person';
import AddIcon from '@mui/icons-material/Add';
import PictureAsPdfIcon from '@mui/icons-material/PictureAsPdf';
//Commponents
import Profiledialog from "../../components/Profiledialog/Profiledialog";
import Confirmdialog from "../../components/Confirmdialog/Confirmdialog";
import Snackbar from "../../components/Snackbar/Snakbar";
import Filterdialog from "../../components/Filterdialog/Filterdialog";
import Imagedialog from "../../components/Imagedialog/Imagedialog";
import Createuser from "../../components/Createuser/Createuser";
import TablePagination from "../../components/Pagination/Pagination";
import IconBtn from "../../components/IconBtn/IconBtn";
import Button from "../../components/Button/Button";
//Libraries
import dayjs from "dayjs";

export default function User(){
    const [t] = useTranslation();
    const [users,setUsers] = useState([]);
    const [profileload,setprofileload] = useState(false);
    const [userinfo,setUserinfo] = useState({});
    const [showprofile, setshowprofile] = useState(false);
    const [showconfirmdialog, setshowconfirmdialog] = useState(false);
    const [showfilterdialog,setshowfilterdialog] = useState(false);
    const [showadduserdialog,setshowadduserdialog] = useState(false);
    const [selectedFilters, setSelectedFilters] = useState({role: "users",});
    const [selectedUserId, setSelectedUserId] = useState(null);
    const [msg,setmsg] = useState();
    const [isopen, setisopen] = useState(false);
    const [openimage,setopenimage] = useState(false);
    const [selectedImage, setSelectedImage] = useState("");
    const {setisloading}=useContext(LoadingContext);
    const [severity, setseverity] = useState("");
    const [page, setPage] = useState(1);

    const rowsPerPage = 12;
    const paginatedUsers = users.slice((page - 1) * rowsPerPage , page * rowsPerPage);
    let role ={ 1:t("مدير النظام"), 2:t("مستخدم"), 3:t("متعهد"), 4:t("مهندس")}
    let status ={ approved:t("مقبول"), rejected:t("مرفوض"), pending:t("قيد الانتظار")}
    let FilterUsers = [
        {
            subtitle: "نوع الحساب",
            icon: <PersonIcon sx={{ color: "#f07c1f" }} />,
            name: "role",
            options: [
            { value: "users", label: "الكل"},
            { value: "contractors", label: "المتعهدون"},
            { value: "engineers", label: "المهندسون"},
            ],
        },
    ]
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
            setmsg(response.data.message);
            setseverity("success");
            await getUsers();
            setprofileload(false);
            setisopen(true);
    }
    async function editActivation(id) {
            setUsers(users =>
                users.map(user =>
                    user.id === id ? { ...user, is_active: !user.is_active }: user
                )
            );
             try {
                const response = await editActivationRequest(id);
                setmsg(response.data.message);
                setseverity("success");
                setisopen(true);
                } catch (error) {
                    setUsers(users =>
                        users.map(user =>
                            user.id === id ? { ...user, is_active: !user.is_active }: user
                        )
                    );
                }        
    }
    async function getFilterUsers(filters) {
        setshowfilterdialog(false);
        setisloading(true);
        await new Promise(resolve => setTimeout(resolve, 1500));
        try{            
                let response = await getFilterUsersRequest(filters.role);
                setUsers(response.data.data);
                setPage(1);
            }finally{
                setisloading(false);
             }

    }        
    useEffect(()=>{getUsers();},[]);
    const profile = userinfo.profile ?? userinfo.contractor_profile ?? userinfo.engineer_profile;
    return(
        <div>  
        {profileload ? (<div className="page"></div>):(
            showprofile && (<Profiledialog
         name={userinfo?.name}
         first_name={profile?.first_name}
         last_name={profile?.last_name}
         image={profile?.full_image_url ? <Avatar  src={profile?.full_image_url} alt="img" sx={{ width: 80, height: 80 }} /> :<AccountCircleIcon  sx={{ color: '#f07c1f' ,fontSize:"80px" }} />}
         email={userinfo?.email}
         phone={profile?.phone}
         location={profile?.location}
         role={role[userinfo?.role_id]}
         children={
            (userinfo.role_id === 4 ?
                ( <>
            <div className="field">
            <span className="label">{t("الاختصاص")}</span>
            <span className="value">{userinfo?.engineer_profile?.specialization}</span>
            </div>
            <div className="field">
            <span className="label">{t("الرقم النقابي")}</span>
            <span className="value">{userinfo?.engineer_profile?.syndicate_number}</span>
            </div>
            <div className="field">
            <span className="label">{t("الدرجة العلمية")}</span>
            <span className="value">{userinfo?.engineer_profile?.degree}</span>
            </div>
             <div className="field">
            <span className="label">{t("سنوات الخبرة")}</span>
            <span className="value">{userinfo?.engineer_profile?.years_of_experience} سنوات</span>
            </div>
            <div className="field">
            <span className="label">{t("الشهادة الجامعية")}</span>
            <IconBtn name="عرض PDF" clr="#e53935"  onClick={() => window.open(userinfo?.engineer_profile?.full_certificate_file_url, "_blank")} icon={<PictureAsPdfIcon sx={{color:"#e53935", fontSize:28}} />} />
            </div>
            {userinfo?.engineer_profile?.full_syndicate_card_image_url?
            <div className="img-field">
            <span className="label">{t("الصور")}</span>
            <div className="cert-thumb" onClick={(e)=>{
                 e.stopPropagation();
                 setSelectedImage(userinfo?.engineer_profile?.full_syndicate_card_image_url);
                 setopenimage(true)}}>
                <img src={userinfo?.engineer_profile?.full_syndicate_card_image_url} alt="" /></div>
                </div>:<></>}
            </>)
           :userinfo.role_id === 3 ?
           (<>
            <div className="field">
            <span className="label">{t("اسم الشركة")}</span>
            <span className="value">{userinfo?.contractor_profile?.company_name}</span>
            </div>
            {userinfo?.contractor_profile.full_commercial_record_url?
            <div className="img-field">
            <span className="label">{t("الصور")}</span>
            <div className="cert-thumb" onClick={(e)=>{
                 e.stopPropagation();
                 setSelectedImage(userinfo?.contractor_profile?.full_commercial_record_url);
                 setopenimage(true)}}>
                <img src={userinfo?.contractor_profile?.full_commercial_record_url} alt="Commercial Record" /></div>
                </div>:<></>}
                </>):null
            )}
         onClose={() => setshowprofile(false)}
          />)
        )}


        {openimage && (<Imagedialog
            src={selectedImage}
            onClose={() => setopenimage(false)}
        />)}


        {showconfirmdialog && (<Confirmdialog
         icon={<DeleteIcon sx={{ color: "#e53935" ,fontSize:65 }}/>}
         title={t("تأكيد الحذف")}
         message={t("هل تريد حذف هذا المستخدم؟")}
         name_btn1={t("إلغاء")}
         btnColor={"#e53935"}
         name_btn2={t("حذف")}
         onClose={() => setshowconfirmdialog(false)}
         onConfirm={() => deleteUser(selectedUserId)}
        />)}


        {showfilterdialog && (<Filterdialog
            groups={FilterUsers}
            title="فلترة المستخدمين"
            onClose={() => setshowfilterdialog(false)}
            onApply={getFilterUsers}
            onReset={() => setSelectedFilters({role: "users",})}
            selectedFilters={selectedFilters}
            setSelectedFilters={setSelectedFilters}
         />)}


        {showadduserdialog && (<Createuser
         onClose={()=>setshowadduserdialog(false)}
         onSuccess={(message) => {
         setmsg(message);
         setseverity("success");
         setisopen(true);
         getUsers();
            }}/>)}

            <Snackbar msg={msg} isopen={isopen} setisopen={setisopen} severity={severity}/>
            <div className="users-table">
            <div className="table-header">
                <h3><GroupIcon sx={{ color: "#f07c1f"}}/> {t("المستخدمين")}</h3>
                <div className="table-actions">
                    <Button className="filter" onClick={() => setshowfilterdialog(true)} icon={<FilterAltIcon sx={{fontSize: "18px"}}/>} text="فلترة"/>
                    <Button className="refresh" onClick={() => {getUsers();setPage(1)}} icon={<RefreshIcon sx={{fontSize: "18px"}}/>} text="تحديث"/>
                    <Button className="add" onClick={() => setshowadduserdialog(true)} icon={<AddIcon sx={{fontSize: "18px"}}/>} text="إضافة"/>

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
                    {paginatedUsers.map((user) => {
                        const profile = user.profile || user.contractor_profile || user.engineer_profile;
                        return(<tr key={user.id}>
                        <td>
                            <div className="avatar">
                                {profile?.full_image_url ? <Avatar  src={profile?.full_image_url} alt="img" sx={{ width: 50, height: 50 }} />:<Avatar  alt=""  sx={{ width: 48, height: 48 , color: "#f07c1f", backgroundColor: "rgba(240, 124, 31, 0.1)"   }} />}
                            </div>
                        </td>
                        <td>{user?.name} </td>
                        <td>{profile?.phone? profile?.phone : t("غير موجود")}</td>
                        <td className="location"><LocationOnIcon sx={{ color: "#f07c1f"}}/>{profile?.location ? profile?.location : t("غير موجود")}</td>
                        <td>{role[user?.role_id]}</td>
                        <td>{dayjs(user?.created_at).format("YYYY-MM-DD")}</td>
                        <td>{status[user?.status]}</td>
                        <td><Switch checked={user.is_active} onChange={() => editActivation(user.id)} color="warning" /></td>
                        <td>
                            <div className="actions">
                            {/* زر العرض */}
                            <IconBtn name="عرض" clr="#2196f3" bgc="rgba(33,150,243,0.1)" h_clr="white" h_bgc="#2196f3" onClick={() =>{setshowprofile(true);showUser(user.id);}} icon={<VisibilityIcon sx={{ fontSize: 24 }} />} />
                            {/* زر الحذف */}
                            {user?.status === "pending"?<></>:
                            <IconBtn name="حذف" clr="#e53935" bgc="rgba(229,57,53,0.1)" h_clr="white" h_bgc="#e53935" onClick={()=>{setSelectedUserId(user.id);setshowconfirmdialog(true)}} icon={<DeleteIcon sx={{ fontSize: 24 }} />} />  
                            }
  
                            </div>
                        </td>
                        </tr>)
                        
                    })}
                    </tbody>
                </table>
            </div>
            <div className="table-footer">
                    <TablePagination
                        count={Math.ceil(users.length / rowsPerPage)}
                        page={page}
                        onChange={(event,value)=>setPage(value)}
                    />
            </div>
        </div>
    </div>
    );
}