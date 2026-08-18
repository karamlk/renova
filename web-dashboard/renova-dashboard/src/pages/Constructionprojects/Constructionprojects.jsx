import "./Constructionprojects.css";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState , useEffect , useContext } from "react";
// MUI 
import ApartmentIcon from '@mui/icons-material/Apartment';
import RefreshIcon from '@mui/icons-material/Refresh';
import VisibilityIcon from '@mui/icons-material/Visibility';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import ArchiveIcon from '@mui/icons-material/Archive';
//api
import {getProjectsRequest} from "../../api/projects";
import {showProjectRequest} from "../../api/projects";
import {archiveProjectRequest} from "../../api/projects";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//Component
import Norequest from "../../components/Norequest/Norequest";
import TablePagination from "../../components/Pagination/Pagination";
import Button from "../../components/Button/Button";
import IconBtn from "../../components/IconBtn/IconBtn";
import Projectdialog from "../../components/Projectdialog/Projectdialog";
import Confirmdialog from "../../components/Confirmdialog/Confirmdialog";
import Snackbar from "../../components/Snackbar/Snakbar";


export default function Constructionprojects() {
    const [t]=useTranslation();
    const {setisloading}=useContext(LoadingContext);
    const [projects,setprojects]=useState([]);
    const [project,setproject]=useState({});
    const [selectedproject,setselectedproject]=useState(null)
    const [page, setPage] = useState(1);
    const [showprojectdialog,setshowprojectdialog]=useState(false);
    const [profileload,setprofileload] = useState(false);
    const [showarchivedialog, setshowarchivedialog] = useState(false);
    const [isopen, setisopen] = useState(false);
    const [severity, setseverity] = useState("");
    const [msg, setmsg] = useState("");
    const rowsPerPage = 12;
    const paginatedProjects = projects.slice((page - 1) * rowsPerPage , page * rowsPerPage);
    let type={restoration:t("ترميم") , construction:t("بناء") , finishing:t("إكساء")};
    let status={active:t("نشط"), completed:t("مكتمل"), cancelled:t("ملغي")}
    //Request
    async function getProjects() {
        setisloading(true);
        let response = await getProjectsRequest();
        await setprojects(response.data.data);
        setisloading(false);
    }
    async function showProject(id) {
        try {
            setprofileload(true);
            const response = await showProjectRequest(id);
            setproject(response.data.data);
            setshowprojectdialog(true);
        } catch (error) {
            console.log("ERROR:", error);
        } finally {
            setprofileload(false);
        }
    }
    async function archiveProject(id){
        setshowarchivedialog(false);
        setprofileload(true);
        try{
         await archiveProjectRequest(id);
         setmsg(t("تم ارشفة المشروع بنجاح"));
         setseverity("success");
         await getProjects();
        }catch(error){
         console.log(error);
        }finally{
         setisopen(true);
         setprofileload(false);      
        }
    }    
    useEffect(() => {
        getProjects();
    }, []);
    return(
    <>
        {profileload ? (<div className="page"></div>):(
        showprojectdialog && <Projectdialog
            onClose={() => setshowprojectdialog(false)}
            id={project?.id}
            pr_name={project?.form?.reconstruction_request?.title}
            pr_type={project?.form?.reconstruction_request?.type}
            status={project?.status}
            progress={project?.progress}
            execution_duration={project?.form?.execution_duration}
            warranty_period={project?.form?.warranty_period}
            date={project?.created_at}
            description={project?.form?.reconstruction_request?.description}
            user_name={project?.user?.name}
            user_email={project?.user?.email}
            user_phone={project?.user?.profile?.phone}
            user_address={project?.user?.profile?.location}
            eng_name={project?.engineer?.name}
            eng_email={project?.engineer?.email}
            eng_phone={project?.engineer?.engineer_profile?.phone}
            eng_address={project?.engineer?.engineer_profile?.location}
            cons_name={project?.contractor?.name}
            cons_email={project?.contractor?.email}
            cons_phone={project?.contractor?.contractor_profile?.phone}
            cons_address={project?.contractor?.contractor_profile?.location}
            materials_cost={project?.form?.materials_cost}
            labor_cost={project?.form?.labor_cost}
            profit={project?.form?.profit}
            total_cost={project?.form?.total_cost}
            tasks={project?.tasks || []}
        />
        )}
        {showarchivedialog && (<Confirmdialog
        icon={<ArchiveIcon sx={{ color: "#f07c1f" ,fontSize:65 }}/>}
         title={t("تأكيد الأرشفة")}
         message={t("هل تريد أرشفة هذا المشروع")}
         name_btn1={t("إلغاء")}
         btnColor={"#f07c1f"}
         name_btn2={t("أرشفة")}
         onClose={() => setshowarchivedialog(false)}
         onConfirm={() => {archiveProject(selectedproject)}}
        />)}
        <Snackbar msg={msg} isopen={isopen} setisopen={setisopen} severity={severity}/>
        <div class="table-body">
            <div class="table-header">
                <h3><ApartmentIcon sx={{ color: "#f07c1f" , fontSize: "28px"}}/> {t("المشاريع")}</h3>
                <div className="table-actions">
                    <Button className="refresh" onClick={() => {getProjects();setPage(1)}} icon={<RefreshIcon sx={{fontSize: "18px"}}/>} text="تحديث"/>
                </div>
            </div>
            {projects.length===0?(<Norequest text="لا يوجد مشاريع"/>):(
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>{t("رقم")}</th>
                            <th>{t("اسم المشروع")}</th>
                            <th>{t("النوع")}</th>
                            <th>{t("الموقع")}</th>
                            <th>{t("صاحب المشروع")}</th>
                            <th>{t("المتعهد")}</th>
                            <th>{t("المهندس")}</th>
                            <th>{t("نسبة الإنجاز")}</th>
                            <th>{t("الحالة")}</th>
                            <th>{t("الإجراءات")}</th>
                        </tr>
                    </thead>
                <tbody>
                    {paginatedProjects.map((project) => (
                        <tr key={project?.id}>
                        <td>#{project?.id}</td>
                        <td>{project?.form?.reconstruction_request?.title}</td>
                        <td>{type[project?.form?.reconstruction_request?.type]}</td>
                        <td><div className="location"><LocationOnIcon sx={{ color: "#f07c1f"}}/>{project?.form?.reconstruction_request?.location}</div></td>
                        <td>{project?.user?.name}</td>
                        <td>{project?.contractor?.name}</td>
                        <td>{project?.engineer?.name}</td>
                        <td>
                            <div className="progress">
                            <div className="progress-bar">
                                <div className="progress-fill" style={{ width: `${project?.progress}%` }}></div>
                            </div>
                            <span>{project?.progress}%</span>
                            </div>
                        </td>                        
                        <td><div className={`type ${project?.status}`}>{status[project?.status]}</div></td>
                        <td>
                            <div className="actions">
                                <IconBtn name="عرض" clr="#2196f3" bgc="rgba(33,150,243,0.1)" h_clr="white" h_bgc="#2196f3" onClick={() =>{showProject(project?.id);}} icon={<VisibilityIcon sx={{ fontSize: 24 }} />} /> 
                                {(project?.status==="completed" || project?.progress===100.00 )?(
                                    <IconBtn name={"أرشفة"} clr={"#FF9800"} bgc={"rgba(255,152,0,0.1)"} h_clr={"white"} h_bgc={"#FF9800"} icon={<ArchiveIcon sx={{fontSize: 24}}/>} onClick={()=>{setselectedproject(project?.id);setshowarchivedialog(true)}}/>
                                ):(<></>)}
                                
                            </div>
                                                   
                        </td>
                        </tr>
                    ))}
                    </tbody>
                </table>
            </div>
            )}
            <div className="table-footer">
                    <TablePagination
                        count={Math.ceil(projects.length / rowsPerPage)}
                        page={page}
                        onChange={(event,value)=>setPage(value)}
                    />
            </div>            
        </div>        
    </>
    )
}